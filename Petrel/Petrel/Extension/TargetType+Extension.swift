//
//  TargetType+Extension.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya


extension TargetType {
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8067")!
    }

    var method: Moya.Method {
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
