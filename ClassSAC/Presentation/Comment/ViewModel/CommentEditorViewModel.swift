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
    }

    struct Output {
        let state: Driver<CommentEditorViewState>
        let route: Signal<CommentEditorRoute>
        let showErrorMessage: Signal<String>
    }

    private enum Constant {
        static let minimumCount = 2
        static let maximumCount = 300
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
        let contentRelay = BehaviorRelay<String>(value: context.mode.initialContent)
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)

        let routeRelay = PublishRelay<CommentEditorRoute>()
        let showErrorMessageRelay = PublishRelay<String>()

        bindContentInput(
            input: input,
            contentRelay: contentRelay
        )

        bindSubmit(
            input: input,
            contentRelay: contentRelay,
            isLoadingRelay: isLoadingRelay,
            routeRelay: routeRelay,
            showErrorMessageRelay: showErrorMessageRelay
        )

        let state = makeStateDriver(
            contentRelay: contentRelay,
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

    func mapCommentError(_ error: Error) -> CommentError {
        (error as? CommentError) ?? .unknown
    }

    func emitErrorMessage(
        from error: Error,
        to relay: PublishRelay<String>
    ) {
        relay.accept(mapCommentError(error).userMessage)
    }

    func bindContentInput(
        input: Input,
        contentRelay: BehaviorRelay<String>
    ) {
        input.viewDidLoad
            .map { [context] in context.mode.initialContent }
            .bind(to: contentRelay)
            .disposed(by: disposeBag)

        input.contentTextDidChange
            .map { String($0.prefix(Constant.maximumCount)) }
            .bind(to: contentRelay)
            .disposed(by: disposeBag)
    }

    func bindSubmit(
        input: Input,
        contentRelay: BehaviorRelay<String>,
        isLoadingRelay: BehaviorRelay<Bool>,
        routeRelay: PublishRelay<CommentEditorRoute>,
        showErrorMessageRelay: PublishRelay<String>
    ) {
        input.didTapConfirmButton
            .withLatestFrom(contentRelay.asObservable())
            .flatMapLatest { [weak self] contentText -> Observable<Comment> in
                guard let self else { return .empty() }

                let trimmedContent = contentText.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !trimmedContent.isEmpty else {
                    showErrorMessageRelay.accept(CommentError.emptyContent.userMessage)
                    return .empty()
                }

                guard trimmedContent.count >= Constant.minimumCount else {
                    showErrorMessageRelay.accept(CommentError.tooShortContent.userMessage)
                    return .empty()
                }

                isLoadingRelay.accept(true)

                switch self.context.mode {
                case .create(let courseID):
                    return self.createCommentUseCase.execute(
                        courseID: courseID,
                        content: trimmedContent
                    )
                    .asObservable()
                    .do(onError: { [weak self] error in
                        isLoadingRelay.accept(false)
                        guard let self else { return }
                        self.emitErrorMessage(from: error, to: showErrorMessageRelay)
                    })
                    .catch { _ in .empty() }

                case .edit(let comment):
                    return self.updateCommentUseCase.execute(
                        courseID: comment.courseID,
                        commentID: comment.id,
                        content: trimmedContent
                    )
                    .asObservable()
                    .do(onError: { [weak self] error in
                        isLoadingRelay.accept(false)
                        guard let self else { return }
                        self.emitErrorMessage(from: error, to: showErrorMessageRelay)
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

    func makeStateDriver(
        contentRelay: BehaviorRelay<String>,
        isLoadingRelay: BehaviorRelay<Bool>
    ) -> Driver<CommentEditorViewState> {
        Observable
            .combineLatest(
                contentRelay.asObservable(),
                isLoadingRelay.asObservable()
            )
            .map { [context] contentText, isLoading in
                let trimmedContent = contentText.trimmingCharacters(in: .whitespacesAndNewlines)

                return CommentEditorViewState(
                    navigationTitle: context.mode.navigationTitle,
                    confirmButtonTitle: context.mode.confirmButtonTitle,
                    courseTitle: context.courseTitle,
                    categoryTitle: context.categoryTitle,
                    contentText: contentText,
                    currentCountText: "\(contentText.count)/\(Constant.maximumCount)",
                    isConfirmButtonEnabled: trimmedContent.count >= Constant.minimumCount && !isLoading,
                    isLoading: isLoading
                )
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
