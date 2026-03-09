//
//  CourseSceneDIContainer.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import UIKit

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

    private lazy var courseRemoteDataSource = CourseRemoteDataSource(
        httpClient: httpClient
    )

    private lazy var commentRemoteDataSource = CommentRemoteDataSource(
        httpClient: httpClient
    )

    private lazy var courseRepository: CourseRepository = DefaultCourseRepository(
        remoteDataSource: courseRemoteDataSource
    )

    private lazy var commentRepository: CommentRepository = DefaultCommentRepository(
        remoteDataSource: commentRemoteDataSource,
        currentUserIDProvider: { nil }
    )

    private lazy var thumbnailProvider: CourseThumbnailProviding = KingfisherCourseThumbnailProvider(
        accessTokenStore: accessTokenStore
    )

    private lazy var courseLikeStatusNotifier: CourseLikeStatusBroadcasting = CourseLikeStatusNotifier()

    private func makeFetchCoursesUseCase() -> FetchCoursesUseCase {
        DefaultFetchCoursesUseCase(courseRepository: courseRepository)
    }

    private func makeSearchCoursesUseCase() -> SearchCoursesUseCase {
        DefaultSearchCoursesUseCase(courseRepository: courseRepository)
    }

    private func makeToggleCourseLikeUseCase() -> ToggleCourseLikeUseCase {
        DefaultToggleCourseLikeUseCase(
            courseRepository: courseRepository,
            courseLikeStatusNotifier: courseLikeStatusNotifier
        )
    }

    private func makeFetchCourseDetailUseCase() -> FetchCourseDetailUseCase {
        DefaultFetchCourseDetailUseCase(courseRepository: courseRepository)
    }

    private func makeFetchCommentsUseCase() -> FetchCommentsUseCase {
        DefaultFetchCommentsUseCase(commentRepository: commentRepository)
    }

    func makeCourseListViewController(
        courseFlowCoordinator: CourseFlowCoordinating
    ) -> CourseListViewController {
        let courseListViewModel = CourseListViewModel(
            fetchCoursesUseCase: makeFetchCoursesUseCase(),
            toggleCourseLikeUseCase: makeToggleCourseLikeUseCase(),
            courseLikeStatusNotifier: courseLikeStatusNotifier
        )

        return CourseListViewController(
            viewModel: courseListViewModel,
            thumbnailProvider: thumbnailProvider,
            courseFlowCoordinator: courseFlowCoordinator
        )
    }

    func makeSearchViewController(
        courseFlowCoordinator: CourseFlowCoordinating
    ) -> SearchViewController {
        let searchViewModel = SearchViewModel(
            searchCoursesUseCase: makeSearchCoursesUseCase(),
            toggleCourseLikeUseCase: makeToggleCourseLikeUseCase(),
            courseLikeStatusNotifier: courseLikeStatusNotifier
        )

        return SearchViewController(
            viewModel: searchViewModel,
            thumbnailProvider: thumbnailProvider,
            courseFlowCoordinator: courseFlowCoordinator
        )
    }

    func makeFavoriteViewController(
        courseFlowCoordinator: CourseFlowCoordinating
    ) -> UIViewController {
        let favoriteViewController = UIViewController()
        favoriteViewController.view.backgroundColor = AppColor.bgPrimary
        favoriteViewController.title = "찜"
        return favoriteViewController
    }

    func makeCourseDetailViewController(
        courseID: String,
        courseFlowCoordinator: CourseFlowCoordinating
    ) -> CourseDetailViewController {
        let courseDetailViewModel = CourseDetailViewModel(
            courseID: courseID,
            fetchCourseDetailUseCase: makeFetchCourseDetailUseCase(),
            fetchCommentsUseCase: makeFetchCommentsUseCase(),
            toggleCourseLikeUseCase: makeToggleCourseLikeUseCase(),
            courseLikeStatusNotifier: courseLikeStatusNotifier
        )

        return CourseDetailViewController(
            viewModel: courseDetailViewModel,
            thumbnailProvider: thumbnailProvider,
            courseFlowCoordinator: courseFlowCoordinator
        )
    }

    func makeCourseCommentListViewController(
        courseID: String,
        courseFlowCoordinator: CourseFlowCoordinating
    ) -> UIViewController {
        let courseCommentListViewController = UIViewController()
        courseCommentListViewController.view.backgroundColor = AppColor.bgPrimary
        courseCommentListViewController.title = "클래스 댓글"
        return courseCommentListViewController
    }

    func makeProfileViewController(
        courseFlowCoordinator: CourseFlowCoordinating
    ) -> UIViewController {
        let profileViewController = UIViewController()
        profileViewController.view.backgroundColor = AppColor.bgPrimary
        profileViewController.title = "프로필"

        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.addAction(
            UIAction { _ in
                courseFlowCoordinator.requestLogout()
            },
            for: .touchUpInside
        )

        profileViewController.view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: profileViewController.view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: profileViewController.view.centerYAnchor)
        ])

        return profileViewController
    }
}
