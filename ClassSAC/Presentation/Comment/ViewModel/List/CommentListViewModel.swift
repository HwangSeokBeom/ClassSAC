//
//  CommentListViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentListViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let didSelectSortOption: Observable<CommentSortOption>
        let didTapWriteButton: Observable<Void>
        let didTapEditButton: Observable<String>
        let didTapDeleteButton: Observable<String>
        let didConfirmDeleteAlert: Observable<Void>
        let didReceiveCommentDidChangeNotification: Observable<Void>
    }

    struct Output {
        let state: Driver<CommentListViewState>
        let route: Signal<CommentListRoute>
        let showDeleteAlert: Signal<CommentListAlert>
        let showErrorMessage: Signal<String>
    }

    private let courseID: String
    private let courseTitle: String
    private let categoryTitle: String
    private let fetchCommentsUseCase: FetchCommentsUseCase
    private let deleteCommentUseCase: DeleteCommentUseCase
    private let currentUserProvider: CurrentUserProviding

    private let disposeBag = DisposeBag()

    private let commentsRelay = BehaviorRelay<[Comment]>(value: [])
    private let sortOptionRelay = BehaviorRelay<CommentSortOption>(value: .latest)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let deleteTargetCommentIDRelay = BehaviorRelay<String?>(value: nil)

    init(
        courseID: String,
        courseTitle: String,
        categoryTitle: String,
        fetchCommentsUseCase: FetchCommentsUseCase,
        deleteCommentUseCase: DeleteCommentUseCase,
        currentUserProvider: CurrentUserProviding
    ) {
        self.courseID = courseID
        self.courseTitle = courseTitle
        self.categoryTitle = categoryTitle
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
        self.currentUserProvider = currentUserProvider
    }

    func transform(input: Input) -> Output {

        let routeRelay = PublishRelay<CommentListRoute>()
        let showDeleteAlertRelay = PublishRelay<CommentListAlert>()
        let showErrorMessageRelay = PublishRelay<String>()

        bindSort(input: input)

        bindFetchComments(
            input: input,
            showErrorMessageRelay: showErrorMessageRelay
        )

        bindWriteRoute(
            input: input,
            routeRelay: routeRelay
        )

        bindEditRoute(
            input: input,
            routeRelay: routeRelay,
            showErrorMessageRelay: showErrorMessageRelay
        )

        bindDeleteAlert(
            input: input,
            showDeleteAlertRelay: showDeleteAlertRelay
        )

        bindDeleteComment(
            input: input,
            showErrorMessageRelay: showErrorMessageRelay
        )

        return Output(
            state: makeStateDriver(),
            route: routeRelay.asSignal(),
            showDeleteAlert: showDeleteAlertRelay.asSignal(),
            showErrorMessage: showErrorMessageRelay.asSignal()
        )
    }
}

private extension CommentListViewModel {

    func mapCommentError(_ error: Error) -> CommentError {
        (error as? CommentError) ?? .unknown
    }

    func emitErrorMessage(
        from error: Error,
        to relay: PublishRelay<String>
    ) {
        relay.accept(mapCommentError(error).userMessage)
    }

    func makeCommentEditorContext(mode: CommentEditorMode) -> CommentEditorContext {
        CommentEditorContext(
            courseID: courseID,
            courseTitle: courseTitle,
            categoryTitle: categoryTitle,
            mode: mode
        )
    }

    func bindSort(input: Input) {
        input.didSelectSortOption
            .bind(to: sortOptionRelay)
            .disposed(by: disposeBag)
    }

    func bindFetchComments(
        input: Input,
        showErrorMessageRelay: PublishRelay<String>
    ) {
        Observable.merge(
            input.viewDidLoad,
            input.didReceiveCommentDidChangeNotification
        )
        .do(onNext: { [weak self] _ in
            self?.isLoadingRelay.accept(true)
        })
        .flatMapLatest { [weak self] _ -> Observable<[Comment]> in
            guard let self else { return .empty() }

            return self.fetchCommentsUseCase.execute(courseID: self.courseID)
                .asObservable()
                .do(
                    onNext: { [weak self] _ in
                        self?.isLoadingRelay.accept(false)
                    },
                    onError: { [weak self] error in
                        self?.isLoadingRelay.accept(false)
                        guard let self else { return }
                        self.emitErrorMessage(from: error, to: showErrorMessageRelay)
                    }
                )
                .catchAndReturn([])
        }
        .bind(to: commentsRelay)
        .disposed(by: disposeBag)
    }

    func bindWriteRoute(
        input: Input,
        routeRelay: PublishRelay<CommentListRoute>
    ) {
        input.didTapWriteButton
            .map { [weak self] _ -> CommentListRoute? in
                guard let self else { return nil }

                return .commentEditor(
                    context: self.makeCommentEditorContext(
                        mode: .create(courseID: self.courseID)
                    )
                )
            }
            .compactMap { $0 }
            .bind(to: routeRelay)
            .disposed(by: disposeBag)
    }

    func bindEditRoute(
        input: Input,
        routeRelay: PublishRelay<CommentListRoute>,
        showErrorMessageRelay: PublishRelay<String>
    ) {
        input.didTapEditButton
            .withLatestFrom(commentsRelay.asObservable()) { commentID, comments in
                (commentID, comments)
            }
            .subscribe(with: self) { owner, payload in
                let (commentID, comments) = payload

                guard let comment = comments.first(where: { $0.id == commentID }) else {
                    showErrorMessageRelay.accept(CommentError.commentNotFound.userMessage)
                    return
                }

                routeRelay.accept(
                    .commentEditor(
                        context: owner.makeCommentEditorContext(
                            mode: .edit(comment: comment)
                        )
                    )
                )
            }
            .disposed(by: disposeBag)
    }

    func bindDeleteAlert(
        input: Input,
        showDeleteAlertRelay: PublishRelay<CommentListAlert>
    ) {
        input.didTapDeleteButton
            .do(onNext: { [weak self] commentID in
                self?.deleteTargetCommentIDRelay.accept(commentID)
            })
            .map { CommentListAlert.delete(commentID: $0) }
            .bind(to: showDeleteAlertRelay)
            .disposed(by: disposeBag)
    }

    func bindDeleteComment(
        input: Input,
        showErrorMessageRelay: PublishRelay<String>
    ) {
        input.didConfirmDeleteAlert
            .withLatestFrom(deleteTargetCommentIDRelay.compactMap { $0 })
            .do(onNext: { [weak self] _ in
                self?.isLoadingRelay.accept(true)
            })
            .flatMapLatest { [weak self] commentID -> Observable<Void> in
                guard let self else { return .empty() }

                return self.deleteCommentUseCase.execute(
                    courseID: self.courseID,
                    commentID: commentID
                )
                .asObservable()
                .do(
                    onNext: { [weak self] _ in
                        self?.isLoadingRelay.accept(false)
                    },
                    onError: { [weak self] error in
                        self?.isLoadingRelay.accept(false)
                        guard let self else { return }
                        self.emitErrorMessage(from: error, to: showErrorMessageRelay)
                    }
                )
                .catchAndReturn(())
            }
            .subscribe(with: self) { owner, _ in
                NotificationCenter.default.post(name: .commentDidChange, object: nil)
                owner.deleteTargetCommentIDRelay.accept(nil)
            }
            .disposed(by: disposeBag)
    }

    func makeStateDriver() -> Driver<CommentListViewState> {
        Observable
            .combineLatest(
                commentsRelay.asObservable(),
                sortOptionRelay.asObservable(),
                isLoadingRelay.asObservable()
            )
            .map { [weak self] comments, sortOption, isLoading in
                guard let self else { return .empty }

                let sortedComments = comments.sorted { left, right in
                    switch sortOption {
                    case .latest:
                        return (left.createdAt ?? .distantPast) > (right.createdAt ?? .distantPast)

                    case .oldest:
                        return (left.createdAt ?? .distantFuture) < (right.createdAt ?? .distantFuture)
                    }
                }

                let currentUserID = self.currentUserProvider.currentUserID

                let commentCellViewModels = sortedComments.map { comment in
                    CommentCellViewModel(
                        commentID: comment.id,
                        writerNickname: comment.writer.nickname,
                        writerProfileImagePath: comment.writer.profileImageURL,
                        contentText: comment.content,
                        createdAtText: CommentTimeFormatter.string(from: comment.createdAt),
                        isMine: comment.writer.userID == currentUserID
                    )
                }

                return CommentListViewState(
                    courseTitle: self.courseTitle,
                    selectedSortOption: sortOption,
                    commentCount: comments.count,
                    commentCellViewModels: commentCellViewModels,
                    isEmptyViewHidden: !commentCellViewModels.isEmpty,
                    isLoading: isLoading
                )
            }
            .asDriver(onErrorJustReturn: .empty)
    }
}
