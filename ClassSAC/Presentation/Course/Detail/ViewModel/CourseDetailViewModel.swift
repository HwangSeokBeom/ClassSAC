//
//  CourseDetailViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import Foundation
import RxSwift
import RxCocoa

final class CourseDetailViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let didTapLikeButton: Observable<Void>
        let didTapMoreCommentsButton: Observable<Void>
    }

    struct Output {
        let state: Driver<CourseDetailViewState>
        let route: Signal<CourseDetailRoute>
        let showError: Signal<CourseError>
        let showToastMessage: Signal<String>
    }

    private enum Message {
        static let undecided = "미정"
        static let noComments = "댓글 0개"
        static let justNow = "방금 전"
    }

    private struct PriceState {
        let originalPriceText: String?
        let salePriceText: String?
        let discountPercentText: String?
        let shouldShowOriginalPrice: Bool
        let shouldShowSalePrice: Bool
        let shouldShowDiscountPercent: Bool
        let isFree: Bool

        static let empty = PriceState(
            originalPriceText: nil,
            salePriceText: nil,
            discountPercentText: nil,
            shouldShowOriginalPrice: false,
            shouldShowSalePrice: false,
            shouldShowDiscountPercent: false,
            isFree: false
        )
    }

    private let courseID: String
    private let fetchCourseDetailUseCase: FetchCourseDetailUseCase
    private let fetchCommentsUseCase: FetchCommentsUseCase
    private let toggleCourseLikeUseCase: ToggleCourseLikeUseCase
    private let courseLikeStatusNotifier: CourseLikeStatusBroadcasting

    private let disposeBag = DisposeBag()

    private let courseDetailRelay = BehaviorRelay<CourseDetail?>(value: nil)
    private let commentsRelay = BehaviorRelay<[Comment]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = PublishRelay<CourseError>()
    private let toastMessageRelay = PublishRelay<String>()

    init(
        courseID: String,
        fetchCourseDetailUseCase: FetchCourseDetailUseCase,
        fetchCommentsUseCase: FetchCommentsUseCase,
        toggleCourseLikeUseCase: ToggleCourseLikeUseCase,
        courseLikeStatusNotifier: CourseLikeStatusBroadcasting
    ) {
        self.courseID = courseID
        self.fetchCourseDetailUseCase = fetchCourseDetailUseCase
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.toggleCourseLikeUseCase = toggleCourseLikeUseCase
        self.courseLikeStatusNotifier = courseLikeStatusNotifier
    }

    func transform(input: Input) -> Output {
        bindFetchCourseDetail(input: input)
        bindFetchComments(input: input)
        bindLikeAction(input: input)
        bindExternalLikeState()

        return Output(
            state: makeStateDriver(),
            route: makeRouteSignal(input: input),
            showError: errorRelay.asSignal(),
            showToastMessage: toastMessageRelay.asSignal()
        )
    }
}

private extension CourseDetailViewModel {

    func bindFetchCourseDetail(input: Input) {
        input.viewDidLoad
            .do(onNext: { [weak self] _ in
                self?.isLoadingRelay.accept(true)
            })
            .flatMapLatest { [weak self] _ -> Observable<CourseDetail> in
                guard let self else { return .empty() }

                return self.fetchCourseDetailUseCase.execute(courseID: self.courseID)
                    .asObservable()
                    .do(
                        onNext: { [weak self] _ in
                            self?.isLoadingRelay.accept(false)
                        },
                        onError: { [weak self] error in
                            self?.isLoadingRelay.accept(false)
                            self?.emitCourseError(from: error)
                        }
                    )
                    .catch { _ in .empty() }
            }
            .bind(to: courseDetailRelay)
            .disposed(by: disposeBag)
    }

    func bindFetchComments(input: Input) {
        input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[Comment]> in
                guard let self else { return .empty() }

                return self.fetchCommentsUseCase.execute(courseID: self.courseID)
                    .asObservable()
                    .do(onError: { [weak self] error in
                        self?.emitCourseError(from: error)
                    })
                    .catchAndReturn([])
            }
            .bind(to: commentsRelay)
            .disposed(by: disposeBag)
    }

    func bindLikeAction(input: Input) {
        input.didTapLikeButton
            .withLatestFrom(courseDetailRelay.compactMap { $0 })
            .flatMapLatest { [weak self] courseDetail -> Observable<CourseLikeResult> in
                guard let self else { return .empty() }

                let targetLikeStatus = !courseDetail.isLiked

                self.updateLikeStateLocally(likeStatus: targetLikeStatus)

                return self.toggleCourseLikeUseCase.execute(
                    courseID: courseDetail.id,
                    likeStatus: targetLikeStatus
                )
                .asObservable()
                .do(onError: { [weak self] error in
                    self?.updateLikeStateLocally(likeStatus: courseDetail.isLiked)
                    self?.emitCourseError(from: error)
                })
                .catch { _ in .empty() }
            }
            .subscribe(with: self) { owner, result in
                owner.updateLikeStateLocally(likeStatus: result.likeStatus)

                guard let courseDetail = owner.courseDetailRelay.value else { return }

                let toastMessage = result.likeStatus
                    ? "\(courseDetail.title) 클래스를 찜했습니다."
                    : "\(courseDetail.title) 클래스 찜을 취소했습니다."

                owner.toastMessageRelay.accept(toastMessage)
            }
            .disposed(by: disposeBag)
    }

    func bindExternalLikeState() {
        courseLikeStatusNotifier.observe()
            .subscribe(with: self) { owner, payload in
                guard let currentCourseDetail = owner.courseDetailRelay.value else { return }
                guard currentCourseDetail.id == payload.courseID else { return }

                owner.courseDetailRelay.accept(
                    currentCourseDetail.updatingLikeState(payload.likeStatus)
                )
            }
            .disposed(by: disposeBag)
    }

    func makeStateDriver() -> Driver<CourseDetailViewState> {
        Observable
            .combineLatest(
                courseDetailRelay.asObservable(),
                commentsRelay.asObservable(),
                isLoadingRelay.asObservable()
            )
            .map { [weak self] courseDetail, comments, isLoading in
                guard let self else { return Self.emptyState }

                guard let courseDetail else {
                    return Self.emptyState.copy(isLoading: isLoading)
                }

                let previewComments = self.previewComments(from: comments)
                let priceState = self.makePriceState(courseDetail: courseDetail)

                return CourseDetailViewState(
                    imageURLs: courseDetail.imageURLs,
                    categoryTitle: courseDetail.category.title,
                    title: courseDetail.title,
                    descriptionText: courseDetail.description,
                    creatorNick: courseDetail.creator.nick,
                    creatorProfileImagePath: courseDetail.creator.profileImageURL,
                    isLiked: courseDetail.isLiked,
                    locationText: self.displayText(courseDetail.location),
                    durationText: self.durationText(from: courseDetail.date),
                    capacityText: self.capacityText(from: courseDetail.capacity),
                    originalPriceText: priceState.originalPriceText,
                    salePriceText: priceState.salePriceText,
                    discountPercentText: priceState.discountPercentText,
                    shouldShowOriginalPrice: priceState.shouldShowOriginalPrice,
                    shouldShowSalePrice: priceState.shouldShowSalePrice,
                    shouldShowDiscountPercent: priceState.shouldShowDiscountPercent,
                    isFree: priceState.isFree,
                    commentCountText: "댓글 \(comments.count)개",
                    commentPreviewCellViewModels: previewComments,
                    isMoreCommentsButtonEnabled: !comments.isEmpty,
                    isLoading: isLoading
                )
            }
            .asDriver(onErrorJustReturn: Self.emptyState)
    }

    func makeRouteSignal(input: Input) -> Signal<CourseDetailRoute> {
        input.didTapMoreCommentsButton
            .withLatestFrom(
                Observable.combineLatest(
                    courseDetailRelay.compactMap { $0 },
                    commentsRelay.asObservable()
                )
            )
            .filter { _, comments in
                !comments.isEmpty
            }
            .map { [courseID] courseDetail, _ in
                CourseDetailRoute.commentList(
                    courseID: courseID,
                    courseTitle: courseDetail.title,
                    categoryTitle: courseDetail.category.title
                )
            }
            .asSignal(onErrorSignalWith: .empty())
    }

    func previewComments(from comments: [Comment]) -> [CourseCommentPreviewCellViewModel] {
        comments
            .sorted { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) }
            .prefix(2)
            .map(makeCommentPreviewCellViewModel)
    }

    func makeCommentPreviewCellViewModel(
        comment: Comment
    ) -> CourseCommentPreviewCellViewModel {
        CourseCommentPreviewCellViewModel(
            commentID: comment.id,
            writerNick: comment.writer.nickname,
            profileImagePath: comment.writer.profileImageURL,
            contentText: comment.content,
            createdAtText: comment.createdAt?.courseCommentDisplayText ?? Message.justNow
        )
    }

    private func makePriceState(courseDetail: CourseDetail) -> PriceState {
        if let price = courseDetail.price,
           let salePrice = courseDetail.salePrice {

            if salePrice == 0 {
                return PriceState(
                    originalPriceText: nil,
                    salePriceText: nil,
                    discountPercentText: nil,
                    shouldShowOriginalPrice: false,
                    shouldShowSalePrice: false,
                    shouldShowDiscountPercent: false,
                    isFree: true
                )
            }

            if price > salePrice {
                return PriceState(
                    originalPriceText: CoursePriceFormatter.formattedPrice(price),
                    salePriceText: CoursePriceFormatter.formattedPrice(salePrice),
                    discountPercentText: CoursePriceFormatter.formattedDiscountPercent(
                        originalPrice: price,
                        salePrice: salePrice
                    ),
                    shouldShowOriginalPrice: true,
                    shouldShowSalePrice: true,
                    shouldShowDiscountPercent: true,
                    isFree: false
                )
            }

            return PriceState(
                originalPriceText: nil,
                salePriceText: CoursePriceFormatter.formattedPrice(price),
                discountPercentText: nil,
                shouldShowOriginalPrice: false,
                shouldShowSalePrice: true,
                shouldShowDiscountPercent: false,
                isFree: false
            )
        }

        if let price = courseDetail.price {
            if price == 0 {
                return PriceState(
                    originalPriceText: nil,
                    salePriceText: nil,
                    discountPercentText: nil,
                    shouldShowOriginalPrice: false,
                    shouldShowSalePrice: false,
                    shouldShowDiscountPercent: false,
                    isFree: true
                )
            }

            return PriceState(
                originalPriceText: nil,
                salePriceText: CoursePriceFormatter.formattedPrice(price),
                discountPercentText: nil,
                shouldShowOriginalPrice: false,
                shouldShowSalePrice: true,
                shouldShowDiscountPercent: false,
                isFree: false
            )
        }

        return .empty
    }

    func displayText(_ value: String?) -> String {
        guard let value,
              !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return Message.undecided
        }
        return value
    }

    func durationText(from minuteString: String?) -> String {
        guard let minuteString,
              let totalMinutes = Int(minuteString) else {
            return Message.undecided
        }

        let hour = totalMinutes / 60
        let minute = totalMinutes % 60
        return "\(hour)시간 \(minute)분"
    }

    func capacityText(from capacity: Int?) -> String {
        guard let capacity else { return Message.undecided }
        return "\(capacity)명"
    }

    func emitCourseError(from error: Error) {
        let courseError = (error as? CourseError) ?? .unknown
        errorRelay.accept(courseError)
    }

    func updateLikeStateLocally(likeStatus: Bool) {
        guard let currentCourseDetail = courseDetailRelay.value else { return }
        courseDetailRelay.accept(currentCourseDetail.updatingLikeState(likeStatus))
    }

    static var emptyState: CourseDetailViewState {
        CourseDetailViewState(
            imageURLs: [],
            categoryTitle: "",
            title: "",
            descriptionText: "",
            creatorNick: "",
            creatorProfileImagePath: nil,
            isLiked: false,
            locationText: Message.undecided,
            durationText: Message.undecided,
            capacityText: Message.undecided,
            originalPriceText: nil,
            salePriceText: nil,
            discountPercentText: nil,
            shouldShowOriginalPrice: false,
            shouldShowSalePrice: false,
            shouldShowDiscountPercent: false,
            isFree: false,
            commentCountText: Message.noComments,
            commentPreviewCellViewModels: [],
            isMoreCommentsButtonEnabled: false,
            isLoading: false
        )
    }
}

private extension CourseDetailViewState {
    func copy(isLoading: Bool) -> CourseDetailViewState {
        CourseDetailViewState(
            imageURLs: imageURLs,
            categoryTitle: categoryTitle,
            title: title,
            descriptionText: descriptionText,
            creatorNick: creatorNick,
            creatorProfileImagePath: creatorProfileImagePath,
            isLiked: isLiked,
            locationText: locationText,
            durationText: durationText,
            capacityText: capacityText,
            originalPriceText: originalPriceText,
            salePriceText: salePriceText,
            discountPercentText: discountPercentText,
            shouldShowOriginalPrice: shouldShowOriginalPrice,
            shouldShowSalePrice: shouldShowSalePrice,
            shouldShowDiscountPercent: shouldShowDiscountPercent,
            isFree: isFree,
            commentCountText: commentCountText,
            commentPreviewCellViewModels: commentPreviewCellViewModels,
            isMoreCommentsButtonEnabled: isMoreCommentsButtonEnabled,
            isLoading: isLoading
        )
    }
}
