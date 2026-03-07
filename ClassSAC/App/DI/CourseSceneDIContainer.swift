//
//  CourseSceneDIContainer.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import Foundation

final class CourseSceneDIContainer {

    private let httpClient: ClassSACHTTPClienting
    private let accessTokenStore: AccessTokenStoring

    init(
        httpClient: ClassSACHTTPClienting,
        accessTokenStore: AccessTokenStoring
    ) {
        self.httpClient = httpClient
        self.accessTokenStore = accessTokenStore
    }

    private lazy var courseRemoteDataSource: CourseRemoteDataSource = CourseRemoteDataSource(
        httpClient: httpClient
    )

    private lazy var courseRepository: CourseRepository = DefaultCourseRepository(
        remoteDataSource: courseRemoteDataSource
    )

    private lazy var thumbnailProvider: CourseThumbnailProviding = KingfisherCourseThumbnailProvider(
        accessTokenStore: accessTokenStore
    )

    private func makeFetchCoursesUseCase() -> FetchCoursesUseCase {
        DefaultFetchCoursesUseCase(courseRepository: courseRepository)
    }

    private func makeToggleCourseLikeUseCase() -> ToggleCourseLikeUseCase {
        DefaultToggleCourseLikeUseCase(courseRepository: courseRepository)
    }

    func makeCourseListViewController() -> CourseListViewController {
        let courseListViewModel = CourseListViewModel(
            fetchCoursesUseCase: makeFetchCoursesUseCase(),
            toggleCourseLikeUseCase: makeToggleCourseLikeUseCase()
        )

        return CourseListViewController(
            viewModel: courseListViewModel,
            thumbnailProvider: thumbnailProvider
        )
    }
}
