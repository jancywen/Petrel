//
//  MoyaProvider+Rx.swift
//  Petrel
//
//  Created by captain on 2020/7/17.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation

import SwiftyJSON
import RxSwift
import Moya

public extension Reactive where Base: MoyaProviderType {
    func converenceRequest(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return Single.create {[weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil, completion: { (result) in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                }
            })
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}


