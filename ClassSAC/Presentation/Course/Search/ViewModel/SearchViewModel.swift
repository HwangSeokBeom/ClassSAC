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
        let showError: Signal<CourseError>
    }

    private let searchCoursesUseCase: SearchCoursesUseCase
    private let toggleCourseLikeUseCase: ToggleCourseLikeUseCase

    private let disposeBag = DisposeBag()

    private let searchedCoursesRelay = BehaviorRelay<[Course]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = PublishRelay<CourseError>()
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

        let state = makeStateDriver()

        let route = input.didTapCourseCell
            .map { SearchRoute.courseDetail(courseID: $0) }
            .asSignal(onErrorSignalWith: .empty())

        return Output(
            state: state,
            route: route,
            showError: errorRelay.asSignal()
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
                        self?.emitCourseError(from: error)
                    })
                    .catchAndReturn([])
            }
            .do(
                onNext: { [weak self] _ in
                    self?.isLoadingRelay.accept(false)
                },
                onError: { [weak self] _ in
                    self?.isLoadingRelay.accept(false)
                }
            )
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
                    self?.emitCourseError(from: error)
                })
                .catchAndReturn(())
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    func makeStateDriver() -> Driver<SearchViewState> {
        Observable
            .combineLatest(
                searchedCoursesRelay.asObservable(),
                isLoadingRelay.asObservable(),
                latestSearchKeywordRelay.asObservable()
            )
            .map { courses, isLoading, latestSearchKeyword in
                
                let courseCellViewModels = courses.map(CourseListCellViewModelMapper.map)

                let emptyState: SearchEmptyState
                
                if isLoading {
                    emptyState = .none
                } else if latestSearchKeyword == nil {
                    emptyState = .initial
                } else if courseCellViewModels.isEmpty {
                    emptyState = .noResult
                } else {
                    emptyState = .none
                }

                return SearchViewState(
                    courses: courseCellViewModels,
                    isLoading: isLoading,
                    emptyState: emptyState
                )
            }
            .asDriver(
                onErrorJustReturn: SearchViewState(
                    courses: [],
                    isLoading: false,
                    emptyState: .initial
                )
            )
    }

    func emitCourseError(from error: Error) {
        let courseError = (error as? CourseError) ?? .unknown
        errorRelay.accept(courseError)
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
            return course.updatingLikeState(isLiked)
        }

        searchedCoursesRelay.accept(updatedCourses)
    }
}
