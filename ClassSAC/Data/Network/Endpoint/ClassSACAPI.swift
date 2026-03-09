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

    case comments(courseId: String)
    case createComment(courseId: String, body: CreateCommentRequestDTO)
    case updateComment(courseId: String, commentId: String, body: UpdateCommentRequestDTO)
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
            return "users/join"

        case .login:
            return "users/login"

        case .myProfile:
            return "users/me/profile"

        case .updateMyProfile:
            return "users/me/profile"

        case .courses:
            return "courses"

        case .courseDetail(let courseId):
            return "courses/\(courseId)"

        case .searchCourses:
            return "courses/search"

        case .likeCourse(let courseId, _):
            return "courses/\(courseId)/like"

        case .comments(let courseId):
            return "courses/\(courseId)/comments"

        case .createComment(let courseId, _):
            return "courses/\(courseId)/comments"

        case .updateComment(let courseId, let commentId, _):
            return "courses/\(courseId)/comments/\(commentId)"

        case .deleteComment(let courseId, let commentId):
            return "courses/\(courseId)/comments/\(commentId)"
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

        case .courses, .courseDetail, .searchCourses, .comments:
            return .get

        case .likeCourse:
            return .post

        case .createComment:
            return .post

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

        case .createComment(_, let body):
            return [
                "content": body.content
            ]

        case .updateComment(_, _, let body):
            return [
                "content": body.content
            ]

        case .likeCourse(_, let likeStatus):
            return [
                "like_status": likeStatus
            ]

        case .updateMyProfile:
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
