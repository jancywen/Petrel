//
//  GoodsAPI.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya

enum GoodsAPI {
    case detail
    case list
    case token
}


extension GoodsAPI: TargetType {
    var path: String {
        switch self {
        case .detail:
            return "detail"
        case .list:
            return "list"
        case .token:
            return "token"
        }
    }
    
    
}
