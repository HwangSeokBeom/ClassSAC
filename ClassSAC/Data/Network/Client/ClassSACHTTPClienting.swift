//
//  ClassSACHTTPClienting.swift
//  CineWave
//
//  Created by Hwangseokbeom on 2/5/26.
//

import Alamofire

protocol ClassSACHTTPClienting {
    func request<T: Decodable>(
        _ endpoint: ClassSACEndpoint,
        as type: T.Type,
        completion: @escaping (Result<T, ClassSACAPIError>) -> Void
    )

    func requestVoid(
        _ endpoint: ClassSACEndpoint,
        completion: @escaping (Result<Void, ClassSACAPIError>) -> Void
    )

    func upload<T: Decodable>(
        _ endpoint: ClassSACEndpoint,
        multipartFormDataBuilder: @escaping (MultipartFormData) -> Void,
        as type: T.Type,
        completion: @escaping (Result<T, ClassSACAPIError>) -> Void
    )
}
