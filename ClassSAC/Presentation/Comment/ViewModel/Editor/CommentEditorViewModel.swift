//
//  CommentEditorViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentEditorViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let contentTextDidChange: Observable<String>
        let didTapConfirmButton: Observable<Void>
        let didTapBackButton: Observable<Void>
    }

    struct Output {
        let state: Driver<CommentEditorViewState>
        let route: Signal<CommentEditorRoute>
        let showErrorMessage: Signal<String>
    }

    private enum Constant {
        static let minimumContentCount = 2
        static let maximumContentCount = 200
    }

    private let context: CommentEditorContext
    private let createCommentUseCase: CreateCommentUseCase
    private let updateCommentUseCase: UpdateCommentUseCase

    private let disposeBag = DisposeBag()

    init(
        context: CommentEditorContext,
        createCommentUseCase: CreateCommentUseCase,
        updateCommentUseCase: UpdateCommentUseCase
    ) {
        self.context = context
        self.createCommentUseCase = createCommentUseCase
        self.updateCommentUseCase = updateCommentUseCase
    }

    func transform(input: Input) -> Output {
        let contentTextRelay = BehaviorRelay<String>(value: context.mode.initialContentText)
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)

        let routeRelay = PublishRelay<CommentEditorRoute>()
        let showErrorMessageRelay = PublishRelay<String>()

        bindInitialContent(
            input: input,
            contentTextRelay: contentTextRelay
        )

        bindContentInput(
            input: input,
            contentTextRelay: contentTextRelay
        )

        bindSubmit(
            input: input,
            contentTextRelay: contentTextRelay,
            isLoadingRelay: isLoadingRelay,
            routeRelay: routeRelay,
            showErrorMessageRelay: showErrorMessageRelay
        )

        bindClose(
            input: input,
            routeRelay: routeRelay
        )

        let state = makeStateDriver(
            contentTextRelay: contentTextRelay,
            isLoadingRelay: isLoadingRelay
        )

        return Output(
            state: state,
            route: routeRelay.asSignal(),
            showErrorMessage: showErrorMessageRelay.asSignal()
        )
    }
}

private extension CommentEditorViewModel {

    func bindInitialContent(
        input: Input,
        contentTextRelay: BehaviorRelay<String>
    ) {
        input.viewDidLoad
            .map { [context] in
                context.mode.initialContentText
            }
            .bind(to: contentTextRelay)
            .disposed(by: disposeBag)
    }

    func bindContentInput(
        input: Input,
        contentTextRelay: BehaviorRelay<String>
    ) {
        input.contentTextDidChange
            .map { text in
                String(text.prefix(Constant.maximumContentCount))
            }
            .bind(to: contentTextRelay)
            .disposed(by: disposeBag)
    }

    func bindSubmit(
        input: Input,
        contentTextRelay: BehaviorRelay<String>,
        isLoadingRelay: BehaviorRelay<Bool>,
        routeRelay: PublishRelay<CommentEditorRoute>,
        showErrorMessageRelay: PublishRelay<String>
    ) {
        input.didTapConfirmButton
            .withLatestFrom(contentTextRelay.asObservable())
            .flatMapLatest { [weak self] contentText -> Observable<Comment> in
                guard let self else { return .empty() }

                let trimmedContentText = contentText.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !trimmedContentText.isEmpty else {
                    showErrorMessageRelay.accept(CommentError.emptyContent.userMessage)
                    return .empty()
                }

                guard trimmedContentText.count >= Constant.minimumContentCount else {
                    showErrorMessageRelay.accept(CommentError.tooShortContent.userMessage)
                    return .empty()
                }

                isLoadingRelay.accept(true)

                switch self.context.mode {
                case .create(let courseID):
                    return self.createCommentUseCase.execute(
                        courseID: courseID,
                        content: trimmedContentText
                    )
                    .asObservable()
                    .do(onError: { [weak self] error in
                        isLoadingRelay.accept(false)
                        self?.emitErrorMessage(from: error, relay: showErrorMessageRelay)
                    })
                    .catch { _ in .empty() }

                case .edit(let comment):
                    return self.updateCommentUseCase.execute(
                        courseID: comment.courseID,
                        commentID: comment.id,
                        content: trimmedContentText
                    )
                    .asObservable()
                    .do(onError: { [weak self] error in
                        isLoadingRelay.accept(false)
                        self?.emitErrorMessage(from: error, relay: showErrorMessageRelay)
                    })
                    .catch { _ in .empty() }
                }
            }
            .subscribe(with: self) { _, _ in
                isLoadingRelay.accept(false)
                NotificationCenter.default.post(name: .commentDidChange, object: nil)
                routeRelay.accept(.close)
            }
            .disposed(by: disposeBag)
    }

    func bindClose(
        input: Input,
        routeRelay: PublishRelay<CommentEditorRoute>
    ) {
        input.didTapBackButton
            .map { CommentEditorRoute.close }
            .bind(to: routeRelay)
            .disposed(by: disposeBag)
    }

    func makeStateDriver(
        contentTextRelay: BehaviorRelay<String>,
        isLoadingRelay: BehaviorRelay<Bool>
    ) -> Driver<CommentEditorViewState> {
        Observable
            .combineLatest(
                contentTextRelay.asObservable(),
                isLoadingRelay.asObservable()
            )
            .map { [context] contentText, isLoading in
                let trimmedContentText = contentText.trimmingCharacters(in: .whitespacesAndNewlines)

                return CommentEditorViewState(
                    navigationTitle: context.mode.navigationTitle,
                    categoryTitle: context.categoryTitle,
                    courseTitle: context.courseTitle,
                    contentText: contentText,
                    countText: "\(contentText.count)/\(Constant.maximumContentCount)",
                    confirmButtonTitle: context.mode.confirmButtonTitle,
                    isConfirmButtonEnabled: trimmedContentText.count >= Constant.minimumContentCount && !isLoading,
                    isLoading: isLoading
                )
            }
            .asDriver(onErrorDriveWith: .empty())
    }

    func emitErrorMessage(
        from error: Error,
        relay: PublishRelay<String>
    ) {
        let commentError = (error as? CommentError) ?? .unknown
        relay.accept(commentError.userMessage)
    }
}
