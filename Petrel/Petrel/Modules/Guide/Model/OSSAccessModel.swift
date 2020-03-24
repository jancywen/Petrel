//
//  OSSAccessModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/13.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct OSSAccessModel:ALSwiftyJSONAble  {
    var endPoint: String
    var visitUrl: String
    var bucket: String
//    var accessKeyId: String
//    var accessKeySecret: String
    var stsServerUrl: String
    
    init?(jsonData: JSON) {
        endPoint = jsonData["endPoint"].stringValue
        visitUrl = jsonData["visitUrl"].stringValue
        bucket = jsonData["bucket"].stringValue
//        accessKeyId = jsonData["accessKeyId"].stringValue
//        accessKeySecret = jsonData["accessKeySecret"].stringValue
        stsServerUrl = jsonData["stsServerUrl"].stringValue
    }
    
}
