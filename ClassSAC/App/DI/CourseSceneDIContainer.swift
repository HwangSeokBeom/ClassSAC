//
//  CourseSceneDIContainer.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

final class CourseSceneDIContainer {

    private let httpClient: ClassSACHTTPClienting

    init(httpClient: ClassSACHTTPClienting) {
        self.httpClient = httpClient
    }

    private lazy var courseRemoteDataSource = CourseRemoteDataSource(
        httpClient: httpClient
    )

    func makeCourseRepository() -> CourseRepository {
        DefaultCourseRepository(
            remoteDataSource: courseRemoteDataSource
        )
    }
}
