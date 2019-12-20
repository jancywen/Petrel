//
//  AddressService.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya
import SwiftyJSON
import Moya_SwiftyJSONMapper
import RxSwift
import RxCocoa

class AddressService {
    func queryAddress() -> Observable<[AddressModel]> {
        provider.rx.request(MultiTarget(AddressAPI.shopping("")))
            .filterSuccessfulStatusCodes()
            .map(to: [AddressModel.self])
            .asObservable()
            .catchError { (error) -> Observable<[AddressModel]> in
                
                return Observable.empty()
        }
    }
    
    
    func simpleAddress() -> Driver<String> {
        return Driver.just("something").delay(1)
    }
    
    func simple() -> Driver<String> {
        return Driver.just("some").delay(2)
    }
}
