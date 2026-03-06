//
//  ClassSACNetworkFactory.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import Alamofire

struct ClassSACNetworkFactory {

    static func makeHTTPClient(
        sesacKeyValue: String,
        accessTokenStore: AccessTokenStoring
    ) -> ClassSACHTTPClient {
        let interceptor = ClassSACRequestInterceptor(
            sesacKeyValue: sesacKeyValue,
            accessTokenStore: accessTokenStore
        )

        let session = Session(interceptor: interceptor)
        let decoder = JSONDecoder()

        return ClassSACHTTPClient(session: session, decoder: decoder)
    }
}
