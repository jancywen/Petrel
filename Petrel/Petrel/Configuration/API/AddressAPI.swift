//
//  AddressAPI.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import Moya

enum AddressAPI {
    case shopping(String)
}


extension AddressAPI: TargetType {
    
    var path: String {
        return "/api/address"
    }
    
}
