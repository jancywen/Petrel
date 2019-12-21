//
//  AddressModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct AddressModel: ALSwiftyJSONAble {
    
    var id: String
    var name: String
    var phone: String
    var detail: String
    var isDefault: Bool
    var fullAddress: String?

    
    init?(jsonData: JSON) {
        id = jsonData["maid"].stringValue
        name = jsonData["name"].stringValue
        phone = jsonData["tel"].stringValue
        detail = jsonData["address"].stringValue
        isDefault = jsonData["is_top"].boolValue
        fullAddress = jsonData["full_name"].stringValue
    }
    
}
