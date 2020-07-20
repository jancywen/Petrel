//
//  TokenModel.swift
//  Petrel
//
//  Created by captain on 2020/7/17.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct Token: ALSwiftyJSONAble {
    
    var products: [TokenProduct]
    var markets: [TokenMarket]
    
    init?(jsonData: JSON) {
        products = jsonData["products"].arrayValue.map{(TokenProduct(jsonData: $0)!)}
        markets = jsonData["markets"].arrayValue.map({TokenMarket(jsonData: $0)!})
    }
}


struct TokenProduct: ALSwiftyJSONAble {

    var token: String?
    
    init?(jsonData: JSON) {
        token = jsonData["token"].string
    }
}


struct TokenMarket: ALSwiftyJSONAble {
    var token: String?
    
    init?(jsonData: JSON) {
        token = jsonData["token"].string
    }
}
