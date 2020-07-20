//
//  TokenAPI.swift
//  Petrel
//
//  Created by captain on 2020/7/17.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Moya


enum TokenAPI {
    
    case token
}

extension TokenAPI: PetrelTargetType {
    var path: String {
        return ""
    }
}
