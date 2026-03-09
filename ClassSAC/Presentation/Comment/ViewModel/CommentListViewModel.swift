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
        let didTapLatestSortButton: Observable<Void>
        let didTapOldestSortButton: Observable<Void>
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
        deleteCommentUseCase: DeleteCommentUseCase
    ) {
        self.courseID = courseID
        self.courseTitle = courseTitle
        self.categoryTitle = categoryTitle
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
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

    func bindSort(input: Input) {
        input.didTapLatestSortButton
            .map { CommentSortOption.latest }
            .bind(to: sortOptionRelay)
            .disposed(by: disposeBag)

        input.didTapOldestSortButton
            .map { CommentSortOption.oldest }
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
            .map { [courseID, courseTitle, categoryTitle] _ in
                CommentListRoute.commentEditor(
                    context: CommentEditorContext(
                        courseID: courseID,
                        courseTitle: courseTitle,
                        categoryTitle: categoryTitle,
                        mode: .create(courseID: courseID)
                    )
                )
            }
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
                comments.first { $0.id == commentID }
            }
            .subscribe(with: self) { owner, comment in
                guard let comment else {
                    showErrorMessageRelay.accept(CommentError.commentNotFound.userMessage)
                    return
                }

                routeRelay.accept(
                    .commentEditor(
                        context: CommentEditorContext(
                            courseID: owner.courseID,
                            courseTitle: owner.courseTitle,
                            categoryTitle: owner.categoryTitle,
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
            .flatMapLatest { [weak self] commentID -> Observable<Void> in
                guard let self else { return .empty() }

                return self.deleteCommentUseCase.execute(
                    courseID: self.courseID,
                    commentID: commentID
                )
                .asObservable()
                .do(onError: { [weak self] error in
                    guard let self else { return }
                    self.emitErrorMessage(from: error, to: showErrorMessageRelay)
                })
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
            .map { [courseTitle] comments, sortOption, isLoading in
                let sortedComments = comments.sorted(by: sortOption)

                let commentCellViewModels = sortedComments.map { comment in
                    CommentCellViewModel(
                        commentID: comment.id,
                        writerUserID: comment.writer.userID,
                        writerNickname: comment.writer.nickname,
                        writerProfileImagePath: comment.writer.profileImageURL,
                        contentText: comment.content,
                        createdAtText: CommentTimeFormatter.string(from: comment.createdAt),
                        isEditButtonHidden: !comment.isWrittenByCurrentUser,
                        isDeleteButtonHidden: !comment.isWrittenByCurrentUser
                    )
                }

                return CommentListViewState(
                    courseTitle: courseTitle,
                    selectedSortTitle: sortOption.title,
                    commentCountText: "댓글 \(comments.count)개",
                    commentCellViewModels: commentCellViewModels,
                    isEmptyViewHidden: !commentCellViewModels.isEmpty,
                    isLoading: isLoading
                )
            }
            .asDriver(onErrorJustReturn: .empty)
    }
}
