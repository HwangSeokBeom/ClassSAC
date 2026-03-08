//
//  DefaultCourseRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/8/26.
//

import Foundation
import RxSwift

final class DefaultCourseRepository: CourseRepository {

    private let remoteDataSource: CourseRemoteDataSource

    init(remoteDataSource: CourseRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchCourses() -> Single<[Course]> {
        remoteDataSource
            .fetchCourses()
            .map { response in
                response.data.map { $0.toEntity() }
            }
            .catch { [weak self] error in
                guard let self else {
                    return .error(CourseError.unknown)
                }
                return .error(self.mapError(error))
            }
    }

    func searchCourses(query: String) -> Single<[Course]> {
        remoteDataSource
            .searchCourses(query: query)
            .map { response in
                response.data.map { $0.toEntity() }
            }
            .catch { [weak self] error in
                guard let self else {
                    return .error(CourseError.unknown)
                }
                return .error(self.mapError(error))
            }
    }

    func toggleCourseLike(
        courseID: String,
        isLiked: Bool
    ) -> Single<Void> {
        remoteDataSource
            .toggleCourseLike(
                courseID: courseID,
                isLiked: isLiked
            )
            .catch { [weak self] error in
                guard let self else {
                    return .error(CourseError.unknown)
                }
                return .error(self.mapError(error))
            }
    }
}

private extension DefaultCourseRepository {

    func mapError(_ error: Error) -> CourseError {
        guard let apiError = error as? ClassSACAPIError else {
            return .unknown
        }

        switch apiError {
        case .statusCode(let code, _):
            switch code {
            case 400:
                return .badRequest
            case 401:
                return .unauthorized
            case 403, 445:
                return .forbidden
            case 404, 410:
                return .notFound
            case 420:
                return .invalidSesacKey
            case 429:
                return .tooManyRequests
            case 500...599:
                return .serverError
            default:
                return .unknown
            }

        case .underlying(let underlyingError):
            if let urlError = underlyingError as? URLError {
                switch urlError.code {
                case .notConnectedToInternet,
                     .timedOut,
                     .cannotFindHost,
                     .cannotConnectToHost,
                     .dnsLookupFailed:
                    return .network
                default:
                    return .unknown
                }
            }
            return .unknown

        case .invalidURL, .decoding, .deallocated:
            return .unknown
        }
    }
}
