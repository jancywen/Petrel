//
//  UploadAPI.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/18.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya

let UploadProvider = MoyaProvider<UploadAPI>()
let provider = MoyaProvider<MultiTarget>()
enum UploadAPI {
    case upload(String)
}

extension UploadAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8067")!
    }
    
    var path: String {
        switch self {
        case .upload(let name):
            return "/api/upload/\(name)"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
