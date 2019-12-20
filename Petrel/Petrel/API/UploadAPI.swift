//
//  UploadAPI.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/18.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya
import RxSwift

let UploadProvider = MoyaProvider<UploadAPI>()
let provider = MoyaProvider<MultiTarget>()


enum UploadAPI {
    case upload(String)
}

extension UploadAPI: TargetType {
    
    var path: String {
        switch self {
        case .upload(let name):
            return "/api/upload/\(name)"
        }
    }
    
}
