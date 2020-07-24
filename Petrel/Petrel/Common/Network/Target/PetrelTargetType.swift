//
//  PetrelTargetType.swift
//  Petrel
//
//  Created by captain on 2020/7/17.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Moya
import RxSwift

let timeout: TimeInterval = 30

let requestTimeoutClosure = {(endpoint:Endpoint, closure:MoyaProvider.RequestResultClosure) in
    if var urlRequest = try? endpoint.urlRequest(){
        urlRequest.timeoutInterval = timeout
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}


protocol PetrelTargetType: TargetType { }

extension PetrelTargetType {
    @discardableResult
    func request(completion: @escaping Completion)  -> Cancellable {
        let provider = MoyaProvider<Self>(requestClosure:requestTimeoutClosure, plugins: [LogPlugin(), StatusCodePlugin()])
        return provider.request(self, completion: completion)
    }
}
