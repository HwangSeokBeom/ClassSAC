//
//  CourseListViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import Foundation
import RxSwift
import RxCocoa

final class CourseListViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let didTapNotificationButton: Observable<Void>
        let didTapProfileButton: Observable<Void>
        let didTapCategoryItem: Observable<CourseCategoryItem>
        let didTapLatestSortButton: Observable<Void>
        let didTapOriginalPriceDescendingSortButton: Observable<Void>
        let didTapCourseCell: Observable<String>
        let didTapLikeButton: Observable<String>
    }

    struct Output {
        let state: Driver<CourseListViewState>
        let route: Signal<CourseListRoute>
        let showError: Signal<CourseError>
    }

    private let fetchCoursesUseCase: FetchCoursesUseCase
    private let toggleCourseLikeUseCase: ToggleCourseLikeUseCase

    private let disposeBag = DisposeBag()

    private let allCoursesRelay = BehaviorRelay<[Course]>(value: [])
    private let selectedCategoryItemsRelay = BehaviorRelay<Set<CourseCategoryItem>>(value: [.all])
    private let selectedSortTypeRelay = BehaviorRelay<CourseSortType>(value: .latest)
    private let errorRelay = PublishRelay<CourseError>()

    private let categoryItems: [CourseCategoryItem] = [
        .all,
        .category(.development),
        .category(.design),
        .category(.foreignLanguage),
        .category(.life),
        .category(.beauty),
        .category(.finance),
        .category(.etc)
    ]

    init(
        fetchCoursesUseCase: FetchCoursesUseCase,
        toggleCourseLikeUseCase: ToggleCourseLikeUseCase
    ) {
        self.fetchCoursesUseCase = fetchCoursesUseCase
        self.toggleCourseLikeUseCase = toggleCourseLikeUseCase
    }

    func transform(input: Input) -> Output {
        bindFetchCourses(input: input)
        bindCategorySelection(input: input)
        bindSortSelection(input: input)
        bindLikeAction(input: input)

        return Output(
            state: makeStateDriver(),
            route: makeRouteSignal(input: input),
            showError: errorRelay.asSignal()
        )
    }
}

private extension CourseListViewModel {

    func bindFetchCourses(input: Input) {
        input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[Course]> in
                guard let self else { return .empty() }

                return self.fetchCoursesUseCase.execute()
                    .asObservable()
                    .do(onError: { [weak self] error in
                        self?.emitCourseError(from: error)
                    })
                    .catchAndReturn([])
            }
            .bind(to: allCoursesRelay)
            .disposed(by: disposeBag)
    }

    func bindCategorySelection(input: Input) {
        input.didTapCategoryItem
            .withLatestFrom(selectedCategoryItemsRelay) { [weak self] tappedCategoryItem, selectedCategoryItems in
                self?.updatedSelectedCategoryItems(
                    tappedCategoryItem: tappedCategoryItem,
                    selectedCategoryItems: selectedCategoryItems
                ) ?? selectedCategoryItems
            }
            .bind(to: selectedCategoryItemsRelay)
            .disposed(by: disposeBag)
    }

    func bindSortSelection(input: Input) {
        input.didTapLatestSortButton
            .map { CourseSortType.latest }
            .bind(to: selectedSortTypeRelay)
            .disposed(by: disposeBag)

        input.didTapOriginalPriceDescendingSortButton
            .map { CourseSortType.originalPriceDescending }
            .bind(to: selectedSortTypeRelay)
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
                    self?.emitCourseError(from: error)
                })
                .catchAndReturn(())
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    func makeStateDriver() -> Driver<CourseListViewState> {
        let coursesObservable = makeFilteredAndSortedCoursesObservable()

        return Observable
            .combineLatest(
                makeCategoryCellViewModelsObservable(),
                coursesObservable,
                selectedSortTypeRelay.asObservable()
            )
            .map { categories, courses, sortType in
                let courseCellViewModels = courses.map(CourseListCellViewModelMapper.map)

                return CourseListViewState(
                    categories: categories,
                    courses: courseCellViewModels,
                    courseCountText: "\(courseCellViewModels.count)개",
                    selectedSortType: sortType
                )
            }
            .asDriver(
                onErrorJustReturn: CourseListViewState(
                    categories: [],
                    courses: [],
                    courseCountText: "0개",
                    selectedSortType: .latest
                )
            )
    }

    func makeRouteSignal(input: Input) -> Signal<CourseListRoute> {
        Signal.merge(
            input.didTapNotificationButton
                .map { CourseListRoute.notifications }
                .asSignal(onErrorSignalWith: .empty()),

            input.didTapProfileButton
                .map { CourseListRoute.profile }
                .asSignal(onErrorSignalWith: .empty()),

            input.didTapCourseCell
                .map { CourseListRoute.courseDetail(courseID: $0) }
                .asSignal(onErrorSignalWith: .empty())
        )
    }

    func makeFilteredAndSortedCoursesObservable() -> Observable<[Course]> {
        Observable
            .combineLatest(
                allCoursesRelay.asObservable(),
                selectedCategoryItemsRelay.asObservable(),
                selectedSortTypeRelay.asObservable()
            )
            .map { [weak self] courses, selectedCategoryItems, selectedSortType in
                guard let self else { return [] }

                let filteredCourses = self.filteredCourses(
                    courses: courses,
                    selectedCategoryItems: selectedCategoryItems
                )

                return self.sortedCourses(
                    courses: filteredCourses,
                    selectedSortType: selectedSortType
                )
            }
            .share(replay: 1, scope: .whileConnected)
    }

    func makeCategoryCellViewModelsObservable() -> Observable<[CourseCategoryCellViewModel]> {
        Observable
            .combineLatest(
                Observable.just(categoryItems),
                selectedCategoryItemsRelay.asObservable()
            )
            .map { categoryItems, selectedCategoryItems in
                categoryItems.map { categoryItem in
                    CourseCategoryCellViewModel(
                        item: categoryItem,
                        title: categoryItem.title,
                        isSelected: selectedCategoryItems.contains(categoryItem)
                    )
                }
            }
    }

    func emitCourseError(from error: Error) {
        let courseError = (error as? CourseError) ?? .unknown
        errorRelay.accept(courseError)
    }

    func updatedSelectedCategoryItems(
        tappedCategoryItem: CourseCategoryItem,
        selectedCategoryItems: Set<CourseCategoryItem>
    ) -> Set<CourseCategoryItem> {
        switch tappedCategoryItem {
        case .all:
            return [.all]

        case .category:
            var updatedSelectedCategoryItems = selectedCategoryItems
            updatedSelectedCategoryItems.remove(.all)

            if updatedSelectedCategoryItems.contains(tappedCategoryItem) {
                updatedSelectedCategoryItems.remove(tappedCategoryItem)
            } else {
                updatedSelectedCategoryItems.insert(tappedCategoryItem)
            }

            return updatedSelectedCategoryItems.isEmpty ? [.all] : updatedSelectedCategoryItems
        }
    }

    func filteredCourses(
        courses: [Course],
        selectedCategoryItems: Set<CourseCategoryItem>
    ) -> [Course] {
        if selectedCategoryItems.contains(.all) {
            return courses
        }

        let selectedCategories = selectedCategoryItems.compactMap { categoryItem -> CourseCategory? in
            switch categoryItem {
            case .all:
                return nil
            case .category(let courseCategory):
                return courseCategory
            }
        }

        return courses.filter { selectedCategories.contains($0.category) }
    }

    func sortedCourses(
        courses: [Course],
        selectedSortType: CourseSortType
    ) -> [Course] {
        switch selectedSortType {
        case .latest:
            return courses.sorted {
                ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast)
            }

        case .originalPriceDescending:
            return courses.sorted { leftCourse, rightCourse in
                let leftOriginalPrice = leftCourse.originalPriceForSort
                let rightOriginalPrice = rightCourse.originalPriceForSort

                let leftIsFree = leftCourse.isFreeForSort
                let rightIsFree = rightCourse.isFreeForSort

                if leftIsFree != rightIsFree {
                    return rightIsFree
                }

                if leftOriginalPrice == rightOriginalPrice {
                    return (leftCourse.createdAt ?? .distantPast) > (rightCourse.createdAt ?? .distantPast)
                }

                return leftOriginalPrice > rightOriginalPrice
            }
        }
    }

    func course(with courseID: String) -> Course? {
        allCoursesRelay.value.first { $0.id == courseID }
    }

    func updateLikeStateLocally(
        courseID: String,
        isLiked: Bool
    ) {
        let updatedCourses = allCoursesRelay.value.map { course in
            guard course.id == courseID else { return course }
            return course.updatingLikeState(isLiked)
        }

        allCoursesRelay.accept(updatedCourses)
    }
}
