//
//  GoodsModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct GoodsModel: ALSwiftyJSONAble {
    
    var goodsId: String
    var goodsName: String
    var count: Int
    var spec: String
    var price: String
    var freight: Decimal
    var shop: Shop
    
    init?(jsonData: JSON) {
        goodsId = jsonData["goods_id"].stringValue
        goodsName = jsonData["goods_name"].stringValue
        count = jsonData["count"].intValue
        spec = jsonData["spec"].stringValue
        price = jsonData["price"].stringValue
        freight = Decimal(jsonData["freight"].doubleValue)
        shop = Shop(jsonData: jsonData)!
    }
    
}

struct Shop: ALSwiftyJSONAble {
    var shopName: String
    var shopId: String
    init?(jsonData: JSON) {
        shopId = jsonData["shop_id"].stringValue
        shopName = jsonData["shop_name"].stringValue
    }
}


struct Invoice: ALSwiftyJSONAble {
    var type: InvoiceType
    init?(jsonData: JSON) {
        type = InvoiceType(rawValue: jsonData["type"].stringValue) ?? .person
    }
}

enum InvoiceType: String {
    case person = "person"
    case company = "company"
}
