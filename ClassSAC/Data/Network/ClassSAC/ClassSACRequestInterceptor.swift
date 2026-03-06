//
//  ClassSACRequestInterceptor.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import Alamofire

final class ClassSACRequestInterceptor: RequestInterceptor {

    private let sesacKeyValue: String
    private let accessTokenStore: AccessTokenStoring

    init(sesacKeyValue: String, accessTokenStore: AccessTokenStoring) {
        self.sesacKeyValue = sesacKeyValue
        self.accessTokenStore = accessTokenStore
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var adaptedRequest = urlRequest

        adaptedRequest.setValue(sesacKeyValue, forHTTPHeaderField: ClassSACHeaderKey.sesacKey)

        let path = adaptedRequest.url?.path ?? ""
        let isAuthExcludedEndpoint = path.contains("/v1/users/join") || path.contains("/v1/users/login")

        if !isAuthExcludedEndpoint, let accessToken = accessTokenStore.accessToken {
            adaptedRequest.setValue(accessToken, forHTTPHeaderField: ClassSACHeaderKey.authorization)
        }

        completion(.success(adaptedRequest))
    }
}
