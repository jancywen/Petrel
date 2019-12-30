//
//  PetrelVideoCell.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/30.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import FSPagerView
import AVKit
import SnapKit

class PetrelVideoCell: FSPagerViewCell {
    
    var videoItem: AVPlayerItem?
    var playerView: PetrelPlayerView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pause() {
        playerView?.pause()
    }
    
    func render(_ url: String, firstImage: String) {
        guard videoItem == nil else { return }
        guard let url = URL(string: url) else { return }
        let item = AVPlayerItem(asset: AVURLAsset(url: url))
        playerView = PetrelPlayerView(playerItem: item, scene: .normal, cover: firstImage)
        
        addSubview(playerView!)
        playerView?.scaleHandler = { [weak self] item in
            
            self?.expandWithItem(item)
        }
        playerView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.videoItem = item
    }
    
    func resumeWithItem(_ item: AVPlayerItem, isPlay: Bool) {
        self.videoItem = item
        self.playerView?.resumeWithItem(item, isPlay: isPlay)
    }
    
    func expandWithItem(_ item: AVPlayerItem) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view.backgroundColor = .black
        
        
        let pView = PetrelPlayerView(playerItem: item, scene: .expanded, cover: "")
        view.addSubview(pView)
        pView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        
        let closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 16, y: TopSafeAreaHeight, width: 44, height: 44)
        closeButton.setImage(UIImage(named: "petrel_video_close"), for: .normal)
        closeButton.add(action: { [weak view, weak pView, weak self] (_) in
            guard let view = view, let p = pView, let self = self else { return }
            view.removeFromSuperview()
            let newItem = AVPlayerItem(asset: p.playerItem.asset)
            newItem.seek(to: p.playerItem.currentTime(), completionHandler: nil)
            self.resumeWithItem(newItem, isPlay: p.isPlay)
            }, for: .touchUpInside)
        view.addSubview(closeButton)
        
        UIApplication.shared.keyWindow?.addSubview(view)
        
        view.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        UIView.animate(withDuration: 0.3) {
            view.transform = CGAffineTransform.identity
        }
    }
    
}
