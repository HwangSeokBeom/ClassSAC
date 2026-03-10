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
    private let currentUserStore: CurrentUserStoring

    init(
        httpClient: ClassSACHTTPClienting,
        accessTokenStore: AccessTokenStoring,
        currentUserStore: CurrentUserStoring
    ) {
        self.httpClient = httpClient
        self.accessTokenStore = accessTokenStore
        self.currentUserStore = currentUserStore
    }

    private lazy var courseRemoteDataSource = CourseRemoteDataSource(
        httpClient: httpClient
    )

    private lazy var commentRemoteDataSource = CommentRemoteDataSource(
        httpClient: httpClient
    )

    private lazy var profileRemoteDataSource = ProfileRemoteDataSource(
        httpClient: httpClient
    )

    private lazy var courseRepository: CourseRepository = DefaultCourseRepository(
        remoteDataSource: courseRemoteDataSource
    )

    private lazy var commentRepository: CommentRepository = DefaultCommentRepository(
        remoteDataSource: commentRemoteDataSource
    )

    private lazy var profileRepository: ProfileRepository = DefaultProfileRepository(
        profileRemoteDataSource: profileRemoteDataSource
    )

    private lazy var sessionRepository: SessionRepository = DefaultSessionRepository(
        accessTokenStore: accessTokenStore,
        currentUserStore: currentUserStore
    )

    private lazy var thumbnailProvider: RemoteImageProviding = KingfisherCourseThumbnailProvider(
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
        DefaultFetchCommentsUseCase(repository: commentRepository)
    }

    private func makeCreateCommentUseCase() -> CreateCommentUseCase {
        DefaultCreateCommentUseCase(commentRepository: commentRepository)
    }

    private func makeUpdateCommentUseCase() -> UpdateCommentUseCase {
        DefaultUpdateCommentUseCase(commentRepository: commentRepository)
    }

    private func makeDeleteCommentUseCase() -> DeleteCommentUseCase {
        DefaultDeleteCommentUseCase(commentRepository: commentRepository)
    }

    private func makeFetchMyProfileUseCase() -> FetchMyProfileUseCase {
        DefaultFetchMyProfileUseCase(profileRepository: profileRepository)
    }

    private func makeLogoutUseCase() -> LogoutUseCase {
        DefaultLogoutUseCase(sessionRepository: sessionRepository)
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
        courseTitle: String,
        categoryTitle: String,
        courseFlowCoordinator: CourseFlowCoordinating
    ) -> CommentListViewController {

        let commentListViewModel = CommentListViewModel(
            courseID: courseID,
            courseTitle: courseTitle,
            categoryTitle: categoryTitle,
            fetchCommentsUseCase: makeFetchCommentsUseCase(),
            deleteCommentUseCase: makeDeleteCommentUseCase(),
            currentUserProvider: currentUserStore
        )

        return CommentListViewController(
            viewModel: commentListViewModel,
            thumbnailProvider: thumbnailProvider,
            courseFlowCoordinator: courseFlowCoordinator
        )
    }

    func makeCommentEditorViewController(
        context: CommentEditorContext
    ) -> CommentEditorViewController {
        let commentEditorViewModel = CommentEditorViewModel(
            context: context,
            createCommentUseCase: makeCreateCommentUseCase(),
            updateCommentUseCase: makeUpdateCommentUseCase()
        )

        return CommentEditorViewController(
            viewModel: commentEditorViewModel
        )
    }

    func makeProfileViewController(
        courseFlowCoordinator: CourseFlowCoordinating
    ) -> ProfileViewController {
        let profileViewModel = ProfileViewModel(
            fetchMyProfileUseCase: makeFetchMyProfileUseCase(),
            logoutUseCase: makeLogoutUseCase()
        )

        return ProfileViewController(
            viewModel: profileViewModel,
            thumbnailProvider: thumbnailProvider
        ) { route in
            switch route {
            case .login:
                courseFlowCoordinator.requestLogout()
            }
        }
    }
}
