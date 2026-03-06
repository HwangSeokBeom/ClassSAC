//
//  ClassSACEndpoint.swift
//  CineWave
//
//  Created by Hwangseokbeom on 2/5/26.
//

import Foundation
import Alamofire

import Foundation
import Alamofire

protocol ClassSACEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var isMultipart: Bool { get }
    var requiresAuthorization: Bool { get }
    var headers: HTTPHeaders { get }
}

extension ClassSACEndpoint {
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var parameters: Parameters? { nil }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var isMultipart: Bool { false }
    var requiresAuthorization: Bool { true }
    var headers: HTTPHeaders { ["Accept": "application/json"] }

    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)

        if !queryItems.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let composed = components?.url else { throw URLError(.badURL) }
            url = composed
        }

        var request = URLRequest(url: url)
        request.method = method
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.name) }

        if !isMultipart, let parameters {
            request = try encoding.encode(request, with: parameters)
        }

        return request
    }
}
