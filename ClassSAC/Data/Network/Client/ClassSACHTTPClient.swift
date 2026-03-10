//
//  ClassSACHTTPClient.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 2/5/26.
//

import Foundation
import Alamofire

final class ClassSACHTTPClient: ClassSACHTTPClienting {

    private let session: Session
    private let decoder: JSONDecoder
    private let accessTokenStore: AccessTokenStoring

    init(
        session: Session,
        decoder: JSONDecoder = .init(),
        accessTokenStore: AccessTokenStoring
    ) {
        self.session = session
        self.decoder = decoder
        self.accessTokenStore = accessTokenStore
    }

    func request<T: Decodable>(
        _ endpoint: ClassSACEndpoint,
        as type: T.Type,
        completion: @escaping (Result<T, ClassSACAPIError>) -> Void
    ) {
        let urlRequest: URLRequest

        do {
            urlRequest = try endpoint.asURLRequest()
        } catch {
            completion(.failure(.invalidURL))
            return
        }

        session.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseData { [weak self, decoder] response in
                guard let self else {
                    completion(.failure(.deallocated))
                    return
                }

                switch response.result {
                case .success(let data):
                    do {
                        let decodedValue = try decoder.decode(T.self, from: data)
                        completion(.success(decodedValue))
                    } catch {
                        completion(.failure(.decoding(error)))
                    }

                case .failure(let afError):
                    let message = Self.extractServerMessage(from: response.data)

                    if let statusCode = response.response?.statusCode {
                        self.handleAuthorizationIfNeeded(
                            statusCode: statusCode,
                            endpoint: endpoint
                        )
                        completion(.failure(.statusCode(statusCode, message: message)))
                    } else {
                        completion(.failure(.underlying(afError)))
                    }
                }
            }
    }

    func requestVoid(
        _ endpoint: ClassSACEndpoint,
        completion: @escaping (Result<Void, ClassSACAPIError>) -> Void
    ) {
        let urlRequest: URLRequest

        do {
            urlRequest = try endpoint.asURLRequest()
        } catch {
            completion(.failure(.invalidURL))
            return
        }

        session.request(urlRequest)
            .validate(statusCode: 200..<300)
            .response { [self] response in
                let statusCode = response.response?.statusCode ?? -1
                let responseBody = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "nil"
                
                if let afError = response.error {
                    let message = Self.extractServerMessage(from: response.data)
                    if let statusCode = response.response?.statusCode {
                        handleAuthorizationIfNeeded(
                            statusCode: statusCode,
                            endpoint: endpoint
                        )
                        completion(.failure(.statusCode(statusCode, message: message)))
                    } else {
                        completion(.failure(.underlying(afError)))
                    }

                    return
                }
                completion(.success(()))
            }
    }

    func upload<T: Decodable>(
        _ endpoint: ClassSACEndpoint,
        multipartFormDataBuilder: @escaping (MultipartFormData) -> Void,
        as type: T.Type,
        completion: @escaping (Result<T, ClassSACAPIError>) -> Void
    ) {
        precondition(endpoint.isMultipart, "multipart 업로드는 endpoint.isMultipart == true 이어야 합니다.")

        let urlRequest: URLRequest

        do {
            urlRequest = try endpoint.asURLRequest()
        } catch {
            completion(.failure(.invalidURL))
            return
        }

        session.upload(
            multipartFormData: multipartFormDataBuilder,
            with: urlRequest
        )
        .validate(statusCode: 200..<300)
        .responseData { [weak self, decoder] response in
            guard let self else {
                completion(.failure(.deallocated))
                return
            }

            switch response.result {
            case .success(let data):
                do {
                    let decodedValue = try decoder.decode(T.self, from: data)
                    completion(.success(decodedValue))
                } catch {
                    completion(.failure(.decoding(error)))
                }

            case .failure(let afError):
                let message = Self.extractServerMessage(from: response.data)

                if let statusCode = response.response?.statusCode {
                    self.handleAuthorizationIfNeeded(
                        statusCode: statusCode,
                        endpoint: endpoint
                    )
                    completion(.failure(.statusCode(statusCode, message: message)))
                } else {
                    completion(.failure(.underlying(afError)))
                }
            }
        }
    }

    private func handleAuthorizationIfNeeded(
        statusCode: Int,
        endpoint: ClassSACEndpoint
    ) {
        guard endpoint.requiresAuthorization else { return }
        guard statusCode == 401 || statusCode == 403 else { return }

        accessTokenStore.clear()
        AuthSessionManager.shared.expireSession()
    }

    private static func extractServerMessage(from data: Data?) -> String? {
        guard let data else { return nil }
        guard
            let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let dictionary = object as? [String: Any]
        else {
            return nil
        }

        return dictionary["message"] as? String
    }
}
