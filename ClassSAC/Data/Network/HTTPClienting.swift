//
//  Untitled.swift
//  CineWave
//
//  Created by Hwangseokbeom on 2/5/26.
//

protocol HTTPClienting {
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        as type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
