//
//  CouponModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/21.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct CouponModel: ALSwiftyJSONAble  {
    
    var id: String
    /// 抵扣金额
    var amount: Decimal
    /// 描述
    var desp: String
    /// 类型
    var type: CouponType
    
    init?(jsonData: JSON) {
        id = jsonData["id"].stringValue
        amount = Decimal(jsonData["amount"].doubleValue)
        desp = jsonData["desp"].stringValue
        type = CouponType(rawValue: jsonData["type"].stringValue) ?? .unkown
    }
}


enum CouponType: String {
    /// 平台
    case platform = "platform"
    /// 品类
    case category = "category"
    /// 商品
    case goods = "goods"
    /// 未知
    case unkown = ""

}
