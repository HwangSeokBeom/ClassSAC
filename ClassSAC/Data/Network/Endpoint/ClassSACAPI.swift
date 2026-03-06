//
//  ClassSACAPI.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import Alamofire

enum ClassSACAPI: ClassSACEndpoint {

    case join(email: String, password: String, nick: String)
    case login(email: String, password: String)
    case myProfile
    case updateMyProfile(nick: String?, profileImageData: Data?)

    case courses(query: CoursesQuery?)
    case courseDetail(courseId: String)
    case searchCourses(query: SearchCoursesQuery)
    case likeCourse(courseId: String, likeStatus: Bool)

    case createComment(courseId: String, content: String)
    case comments(courseId: String)
    case updateComment(courseId: String, commentId: String, content: String)
    case deleteComment(courseId: String, commentId: String)

    var baseURL: URL {
        guard let url = URL(string: Secrets.BaseURL) else {
            fatalError("Invalid Secrets.BaseURL")
        }

        return url
    }

    var path: String {
        switch self {
        case .join:
            return "v1/users/join"

        case .login:
            return "v1/users/login"

        case .myProfile:
            return "v1/users/me/profile"

        case .updateMyProfile:
            return "v1/users/me/profile"

        case .courses:
            return "v1/courses"

        case .courseDetail(let courseId):
            return "v1/courses/\(courseId)"

        case .searchCourses:
            return "v1/courses/search"

        case .likeCourse(let courseId, _):
            return "v1/courses/\(courseId)/like"

        case .createComment(let courseId, _):
            return "v1/courses/\(courseId)/comments"

        case .comments(let courseId):
            return "v1/courses/\(courseId)/comments"

        case .updateComment(let courseId, let commentId, _):
            return "v1/courses/\(courseId)/comments/\(commentId)"

        case .deleteComment(let courseId, let commentId):
            return "v1/courses/\(courseId)/comments/\(commentId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .join, .login:
            return .post

        case .myProfile:
            return .get

        case .updateMyProfile:
            return .put

        case .courses, .courseDetail, .searchCourses:
            return .get

        case .likeCourse:
            return .post

        case .createComment:
            return .post

        case .comments:
            return .get

        case .updateComment:
            return .put

        case .deleteComment:
            return .delete
        }
    }

    var requiresAuthorization: Bool {
        switch self {
        case .join, .login:
            return false

        default:
            return true
        }
    }

    var isMultipart: Bool {
        switch self {
        case .updateMyProfile:
            return true

        default:
            return false
        }
    }

    var headers: HTTPHeaders {
        var defaultHeaders: HTTPHeaders = [
            "Accept": "application/json"
        ]

        if !isMultipart {
            defaultHeaders.add(name: "Content-Type", value: "application/json")
        }

        return defaultHeaders
    }

    var query: ClassSACQuery? {
        switch self {
        case .courses(let query):
            return query

        case .searchCourses(let query):
            return query

        default:
            return nil
        }
    }

    var parameters: Parameters? {
        switch self {
        case .join(let email, let password, let nick):
            return [
                "email": email,
                "password": password,
                "nick": nick
            ]

        case .login(let email, let password):
            return [
                "email": email,
                "password": password
            ]

        case .createComment(_, let content):
            return [
                "content": content
            ]

        case .updateComment(_, _, let content):
            return [
                "content": content
            ]

        case .likeCourse(_, let likeStatus):
            return [
                "like_status": likeStatus
            ]

        case .updateMyProfile(let nick, _):
            _ = nick
            return nil

        default:
            return nil
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .courses, .courseDetail, .comments, .myProfile, .searchCourses:
            return URLEncoding.default

        default:
            return JSONEncoding.default
        }
    }
}
