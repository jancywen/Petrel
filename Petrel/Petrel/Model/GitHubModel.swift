//
//  GitHubModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper

struct GitHubRepositories: ALSwiftyJSONAble {
    var totalCount: Int
    var incompleteResults: Bool
    var items:[GitHubRepository]
    init?(jsonData: JSON) {
        totalCount = jsonData["total_count"].intValue
        incompleteResults = jsonData["incomplete_results"].boolValue
        items = jsonData["items"].arrayValue.map{GitHubRepository(jsonData: $0)!}
    }
    
}


struct GitHubRepository: ALSwiftyJSONAble {
    var id: Int
    var name: String
    var fullName:String
    var htmlUrl: String
    var description: String
    init?(jsonData: JSON) {
        id = jsonData["id"].intValue
        name = jsonData["name"].stringValue
        fullName = jsonData["full_name"].stringValue
        htmlUrl = jsonData["html_url"].stringValue
        description = jsonData["description"].stringValue
    }
}
