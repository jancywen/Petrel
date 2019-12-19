//
//  OSSService.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/13.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import RxSwift

struct OSSNetworkService {
     static func ossAccess() -> Observable<OSSAccessModel> {
        OSSProvider.rx.request(.oss)
            .filterSuccessfulStatusCodes()
            .map(to: OSSAccessModel.self)
            .asObservable()
            .catchError { (error) -> Observable<OSSAccessModel> in
            return Observable<OSSAccessModel>.empty()
        }
    }
}

