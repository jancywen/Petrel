//
//  DouBan.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation

import SwiftyJSON
import Moya_SwiftyJSONMapper


struct DouBan: ALSwiftyJSONAble {
    var channels: [Channel]
    init?(jsonData: JSON) {
        channels = jsonData["channels"].arrayValue.map{(Channel(jsonData: $0)!)}
    }
}
struct Channel: ALSwiftyJSONAble {
    var name: String
    var channelId: String
    
    init?(jsonData: JSON) {
        name = jsonData["name"].stringValue
        channelId = jsonData["channel_id"].stringValue
    }
}

struct Playlist: ALSwiftyJSONAble {
    var song:[Song]
    init?(jsonData: JSON) {
        song = jsonData["song"].arrayValue.map{Song(jsonData: $0)!}
    }
}

struct Song: ALSwiftyJSONAble{
    var title: String
    var artist: String
    init?(jsonData: JSON) {
        title = jsonData["title"].stringValue
        artist = jsonData["artist"].stringValue
    }
}


extension Channel:Codable{}
extension Channel:ConvertToStringable {
    typealias Result = Channel
    var valueString: String { return toString(result: self) }
}
