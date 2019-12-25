//
//  GoodsInfo.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON


struct Goods: ALSwiftyJSONAble {
    var id: String

    init?(jsonData: JSON) {
        id = jsonData["id"].stringValue
    }
    
}
