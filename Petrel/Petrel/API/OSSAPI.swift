//
//  OSSAPI.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/13.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import Moya

let OSSProvider = MoyaProvider<OSSAPI>()

enum OSSAPI {
    case oss
}

extension OSSAPI:TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        return "/api/oss"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
