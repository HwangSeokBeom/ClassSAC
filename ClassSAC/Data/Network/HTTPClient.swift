//
//  HTTPClient.swift
//  CineWave
//
//  Created by Hwangseokbeom on 2/5/26.
//

import Foundation
import Alamofire

final class HTTPClient: HTTPClienting {

    private let session: Session
    private let decoder: JSONDecoder

    init(session: Session, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(
        _ endpoint: Endpoint,
        as type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {

        let req: URLRequest
        do {
            req = try endpoint.asURLRequest()
        } catch {
            completion(.failure(.invalidURL))
            return
        }

        session.request(req)
            .validate(statusCode: 200..<300)
            .responseData { [decoder] response in

                switch response.result {

                case .success(let data):
                    do {
                        let value = try decoder.decode(T.self, from: data)
                        completion(.success(value))
                    } catch {
                        completion(.failure(.decoding(error)))
                    }

                case .failure(let afError):
                    if let code = response.response?.statusCode {
                        completion(.failure(.statusCode(code, message: nil)))
                    } else {
                        completion(.failure(.underlying(afError)))
                    }
                }
            }
    }
}
