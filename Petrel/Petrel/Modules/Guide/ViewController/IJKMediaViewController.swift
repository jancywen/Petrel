//
//  IJKMediaViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/1/7.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import IJKMediaFramework

class IJKMediaViewController: UIViewController {
    
    var player: IJKFFMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = IJKFFOptions.byDefault()
        
        //视频源地址
        let url = URL(string: "http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8")
        //let url = NSURL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")
        
        //初始化播放器，播放在线视频或直播（RTMP）
        let player = IJKFFMoviePlayerController(contentURL: url, with: options)
        //播放页面视图宽高自适应
        let autoresize = UIView.AutoresizingMask.flexibleWidth.rawValue |
            UIView.AutoresizingMask.flexibleHeight.rawValue
        player?.view.autoresizingMask = UIView.AutoresizingMask(rawValue: autoresize)
        
        player?.view.frame = self.view.bounds
        player?.scalingMode = .aspectFit //缩放模式
        player?.shouldAutoplay = true //开启自动播放
        
        self.view.autoresizesSubviews = true
        self.view.addSubview(player!.view)
        self.player = player
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //开始播放
        self.player.prepareToPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //关闭播放器
        self.player.shutdown()
    }
    
    
}
