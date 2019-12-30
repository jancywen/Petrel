//
//  PrtrelPlayerView.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/30.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import AVKit

enum Operation {
    /// 展示暂停键
    case showPause
    /// 播放
    case play
    /// 重播
    case replay
    /// 暂停
    case pause
    /// 放大缩小
    case scale
}


enum Scene {
    /// 缩略场景
    case normal
    /// 放大
    case expanded
}

class PetrelPlayerView: UIView {
    
    var isPlay: Bool {
        return (nextOperator == .showPause || nextOperator == .pause)
    }
    
    var scaleHandler: ((AVPlayerItem) ->Void)?
    
    let scene: Scene
    
    func resumeWithItem(_ item: AVPlayerItem, isPlay: Bool) {
        self.playerItem = item
        self.player.replaceCurrentItem(with: item)
        if isPlay {
            play()
        } else {
            pause()
        }
    }
    
    init(playerItem: AVPlayerItem, scene: Scene, cover: String) {
        
        self.scene = scene
        self.playerItem = playerItem
        switch scene {
        case .expanded:
            self.nextOperator = .showPause
        case .normal:
            self.nextOperator = .play
        }
        super.init(frame: .zero)
        
        self.player.replaceCurrentItem(with: playerItem)
        
        backgroundColor = .black
        layer.addSublayer(playLayer)
        
        addSubview(firstImageView)
        firstImageView.setImage(cover)
        firstImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        addSubview(operatorButton)
        operatorButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        playLayer.player = player
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
        if case .expanded = self.scene {
            self.player.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playLayer.frame = bounds
    }
    
    @objc func onEnd() {
        nextOperator = .replay
    }
    
    @objc func onClickOpearator() {
        switch nextOperator {
        case .play:
            play()
        case .replay:
            replay()
        case .pause:
            pause()
        case .showPause:
            showPause()
        case .scale:
            onScale()
        }
    }
    
    func onScale() {
        player.pause()
        
        let item = AVPlayerItem(asset: playerItem.asset)
        item.seek(to: playerItem.currentTime(), completionHandler: nil)
        scaleHandler?(item)
    }
    
    func showPause() {
        nextOperator = .pause
        
        operatorButton.setImage(UIImage(named: "petrel_video_pause"), for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.nextOperator == .pause {
                self.operatorButton.isHidden = true
            }
        }
    }
    
    func replay() {
        let time = CMTimeMake(value: 0, timescale: 1)
        player.seek(to: time) { [weak self] (_) in
            self?.player.play()
        }
        nextOperator = .pause
        
        operatorButton.setImage(nil, for: .normal)
    }
    
    func pause() {
        player.pause()
        nextOperator = .play
        
        operatorButton.setImage(UIImage(named: "petrel_video_play"), for: .normal)
    }
    
    func play() {
        player.play()
        
        switch scene {
        case .normal:
            nextOperator = .scale
        case .expanded:
            nextOperator = .showPause
        }
        operatorButton.setImage(nil, for: .normal)
        
        // 隐藏封面
        firstImageView.isHidden = true
    }
    
    lazy var firstImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var nextOperator: Operation
    
    lazy var operatorButton: UIButton = {
        let b = UIButton(title: "", textColor: .red, font: UIFont(type: .regular, size: 18))
        b.addTarget(self, action: #selector(onClickOpearator), for: .touchUpInside)
        return b
    }()
    
    lazy var player: AVPlayer = {
        let p = AVPlayer(playerItem: nil)
        return p
    }()
    
    lazy var playLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: nil)
        return layer
    }()
    
    var playerItem: AVPlayerItem
}

