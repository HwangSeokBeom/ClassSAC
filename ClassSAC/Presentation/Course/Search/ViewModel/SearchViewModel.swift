//
//  SearchViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {

    struct Input {
        let searchButtonClicked: Observable<String>
        let didTapCourseCell: Observable<String>
        let didTapLikeButton: Observable<String>
    }

    struct Output {
        let state: Driver<SearchViewState>
        let route: Signal<SearchRoute>
        let showErrorMessage: Signal<String>
    }

    private let searchCoursesUseCase: SearchCoursesUseCase
    private let toggleCourseLikeUseCase: ToggleCourseLikeUseCase

    private let disposeBag = DisposeBag()

    private let searchedCoursesRelay = BehaviorRelay<[Course]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = PublishRelay<String>()
    private let latestSearchKeywordRelay = BehaviorRelay<String?>(value: nil)

    init(
        searchCoursesUseCase: SearchCoursesUseCase,
        toggleCourseLikeUseCase: ToggleCourseLikeUseCase
    ) {
        self.searchCoursesUseCase = searchCoursesUseCase
        self.toggleCourseLikeUseCase = toggleCourseLikeUseCase
    }

    func transform(input: Input) -> Output {
        bindSearch(input: input)
        bindLikeAction(input: input)

        let state = Observable
            .combineLatest(
                searchedCoursesRelay.asObservable(),
                isLoadingRelay.asObservable()
            )
            .map { [weak self] courses, isLoading -> SearchViewState in
                guard let self else {
                    return SearchViewState(
                        courses: [],
                        isLoading: false,
                        emptyMessage: nil
                    )
                }

                let courseCellViewModels = courses.map {
                    self.makeCourseListCellViewModel(course: $0)
                }

                let emptyMessage: String?
                if isLoading {
                    emptyMessage = nil
                } else if latestSearchKeywordRelay.value == nil {
                    emptyMessage = "검색어를 입력해 클래스를 검색해보세요."
                } else if courseCellViewModels.isEmpty {
                    emptyMessage = "검색 결과가 없습니다."
                } else {
                    emptyMessage = nil
                }

                return SearchViewState(
                    courses: courseCellViewModels,
                    isLoading: isLoading,
                    emptyMessage: emptyMessage
                )
            }
            .asDriver(onErrorDriveWith: .empty())

        let route = input.didTapCourseCell
            .map { SearchRoute.courseDetail(courseID: $0) }
            .asSignal(onErrorSignalWith: .empty())

        return Output(
            state: state,
            route: route,
            showErrorMessage: errorMessageRelay.asSignal()
        )
    }
}

private extension SearchViewModel {

    func bindSearch(input: Input) {
        input.searchButtonClicked
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .withLatestFrom(latestSearchKeywordRelay.asObservable()) { newKeyword, latestKeyword in
                (newKeyword, latestKeyword)
            }
            .filter { newKeyword, latestKeyword in
                newKeyword != latestKeyword
            }
            .map(\.0)
            .do(onNext: { [weak self] keyword in
                self?.latestSearchKeywordRelay.accept(keyword)
                self?.isLoadingRelay.accept(true)
            })
            .flatMapLatest { [weak self] keyword -> Observable<[Course]> in
                guard let self else { return .empty() }

                return self.searchCoursesUseCase.execute(query: keyword)
                    .asObservable()
                    .do(onError: { [weak self] error in
                        self?.errorMessageRelay.accept(
                            self?.errorMessage(from: error) ?? "검색 중 오류가 발생했습니다."
                        )
                    })
                    .catchAndReturn([])
            }
            .do(onNext: { [weak self] _ in
                self?.isLoadingRelay.accept(false)
            })
            .bind(to: searchedCoursesRelay)
            .disposed(by: disposeBag)
    }

    func bindLikeAction(input: Input) {
        input.didTapLikeButton
            .compactMap { [weak self] courseID -> Course? in
                self?.course(with: courseID)
            }
            .flatMapLatest { [weak self] course -> Observable<Void> in
                guard let self else { return .empty() }

                let toggledLikeState = !course.isLiked

                self.updateLikeStateLocally(
                    courseID: course.id,
                    isLiked: toggledLikeState
                )

                return self.toggleCourseLikeUseCase.execute(
                    courseID: course.id,
                    isLiked: toggledLikeState
                )
                .asObservable()
                .do(onError: { [weak self] error in
                    self?.updateLikeStateLocally(
                        courseID: course.id,
                        isLiked: course.isLiked
                    )
                    self?.errorMessageRelay.accept(
                        self?.errorMessage(from: error) ?? "찜 처리 중 오류가 발생했습니다."
                    )
                })
                .catchAndReturn(())
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    func errorMessage(from error: Error) -> String {
        if let apiError = error as? ClassSACAPIError {
            return apiError.userMessage
        }

        return "오류가 발생했습니다."
    }

    func course(with courseID: String) -> Course? {
        searchedCoursesRelay.value.first { $0.id == courseID }
    }

    func updateLikeStateLocally(
        courseID: String,
        isLiked: Bool
    ) {
        let updatedCourses = searchedCoursesRelay.value.map { course in
            guard course.id == courseID else { return course }

            return Course(
                id: course.id,
                category: course.category,
                title: course.title,
                description: course.description,
                price: course.price,
                salePrice: course.salePrice,
                thumbnailURL: course.thumbnailURL,
                imageURLs: course.imageURLs,
                createdAt: course.createdAt,
                isLiked: isLiked,
                creatorNick: course.creatorNick
            )
        }

        searchedCoursesRelay.accept(updatedCourses)
    }

    func makeCourseListCellViewModel(course: Course) -> CourseListCellViewModel {
        switch course.coursePrice {
        case .free:
            return CourseListCellViewModel(
                courseID: course.id,
                thumbnailImageURLString: course.thumbnailURL,
                categoryTitle: course.category.title,
                title: course.title,
                descriptionText: course.description,
                creatorNick: course.creatorNick,
                isLiked: course.isLiked,
                originalPriceText: nil,
                salePriceText: nil,
                discountPercentText: nil,
                shouldShowOriginalPrice: false,
                shouldShowSalePrice: false,
                shouldShowDiscountPercent: false,
                isFree: true
            )

        case .normal(let price):
            return CourseListCellViewModel(
                courseID: course.id,
                thumbnailImageURLString: course.thumbnailURL,
                categoryTitle: course.category.title,
                title: course.title,
                descriptionText: course.description,
                creatorNick: course.creatorNick,
                isLiked: course.isLiked,
                originalPriceText: nil,
                salePriceText: CoursePriceFormatter.formattedPrice(price),
                discountPercentText: nil,
                shouldShowOriginalPrice: false,
                shouldShowSalePrice: true,
                shouldShowDiscountPercent: false,
                isFree: false
            )

        case .discounted(let originalPrice, let salePrice):
            return CourseListCellViewModel(
                courseID: course.id,
                thumbnailImageURLString: course.thumbnailURL,
                categoryTitle: course.category.title,
                title: course.title,
                descriptionText: course.description,
                creatorNick: course.creatorNick,
                isLiked: course.isLiked,
                originalPriceText: CoursePriceFormatter.formattedPrice(originalPrice),
                salePriceText: CoursePriceFormatter.formattedPrice(salePrice),
                discountPercentText: CoursePriceFormatter.formattedDiscountPercent(
                    originalPrice: originalPrice,
                    salePrice: salePrice
                ),
                shouldShowOriginalPrice: true,
                shouldShowSalePrice: true,
                shouldShowDiscountPercent: true,
                isFree: false
            )
        }
    }
}
