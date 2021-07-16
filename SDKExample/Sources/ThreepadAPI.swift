//
//  ThreepadAPI.swift
//  SDKExample
//
//  Created by Scott McKenzie on 10/5/20.
//  Copyright © 2020 GoSkip. All rights reserved.
//

import Foundation
import SkipTools

public class ThreepadAPI: API {
    static var threepadBaseURL = "http://threepad-sandbox.skipapi.io/"

    public enum Endpoint {
        case startCart(storeId: Int)
        case tenderCart(cartId: Int)

        //Will return the url for the given endpoint.
        var url: String {
            switch self {
            case .startCart: return ThreepadAPI.threepadBaseURL + "shopping/start"
            case .tenderCart: return ThreepadAPI.threepadBaseURL + "shopping/tender"
            }
        }

        //Will return the HttpMethod for a given endpoint.
        var method: HttpMethod {
            switch self {
            case .startCart: return .post
            case .tenderCart: return    .post
            }
        }

        //Will return the params required for a given endpoint.
        func params() -> [String: Any?] {
            switch self {
            case let .startCart(storeId): return ["store_id": storeId]
            case let .tenderCart(cartId): return ["cart_id": cartId]
            }
        }
    }

    public init() {
    }

    // MARK: - API

    @discardableResult
    public func requestData<T: Unwind>(for endpoint: Endpoint, response: Response<T>?) -> URLSessionDataTask {
        return requestJSON(endpoint.url, method: endpoint.method, parameters: endpoint.params(), auth: Auth.current, completion: { json in
            if let value: T = json<-? {
                response?(value, json.statusCode ?? 200, nil)
            } else {
                response?(nil, json.statusCode ?? 500, json.jsonError ?? HttpError(description: "Could not instantiate type: \(T.self) from json", statusCode: 500))
            }
        })
    }

    @discardableResult
    public func requestData<T: Decodable>(for endpoint: Endpoint, response: Response<T>?) -> URLSessionDataTask {
        return requestJSON(endpoint.url, method: endpoint.method, parameters: endpoint.params(), auth: Auth.current, completion: { json in
            do {
                let data = try SnakedJSONDecoder().decode(T.self, from: json.data)
                response?(data, json.statusCode ?? 200, nil)
            } catch {
                response?(nil, json.statusCode ?? 500, json.jsonError ?? HttpError(description: error.localizedDescription, statusCode: 500))
            }
        })
    }
}
