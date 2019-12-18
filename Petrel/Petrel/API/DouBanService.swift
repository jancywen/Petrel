//
//  DouBanService.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct DouBanService {
    /// 获取频道
    static func loadChannels() -> Observable<[Channel]> {
        return provider.rx.request(MultiTarget(DouBanAPI.channels)).map(to: DouBan.self).map{$0.channels}.asObservable()
    }
    /// 获取频道歌曲
    static func loadPlayList(channelId: String) -> Observable<Playlist> {
        return provider.rx.request(MultiTarget(DouBanAPI.playlist(channelId))).map(to: Playlist.self).asObservable()
    }
    /// 获取频道下的第一首歌
    static func loadFirstSong(channelId: String) -> Observable<Song> {
        return loadPlayList(channelId: channelId).filter{$0.song.count > 0}.map{$0.song[0]}
    }
}
