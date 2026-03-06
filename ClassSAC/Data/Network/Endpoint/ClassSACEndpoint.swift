//
//  ClassSACEndpoint.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import Alamofire

protocol ClassSACEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: ClassSACQuery? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var isMultipart: Bool { get }
    var requiresAuthorization: Bool { get }
    var headers: HTTPHeaders { get }
}

extension ClassSACEndpoint {
    var method: HTTPMethod { .get }
    var query: ClassSACQuery? { nil }
    var parameters: Parameters? { nil }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var isMultipart: Bool { false }
    var requiresAuthorization: Bool { true }
    var headers: HTTPHeaders { ["Accept": "application/json"] }

    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)

        if let query {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = query.queryItems

            guard let composedURL = urlComponents?.url else {
                throw URLError(.badURL)
            }

            url = composedURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.method = method

        headers.forEach { header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
        }

        if !isMultipart, let parameters {
            urlRequest = try encoding.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }
}
