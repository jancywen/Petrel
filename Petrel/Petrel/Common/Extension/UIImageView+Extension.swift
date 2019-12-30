//
//  UIImageView+Extension.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/30.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import Kingfisher
import SKPhotoBrowser

extension UIImageView {
    /// 设置网络图片
    func setImage(_ url: String?) {
        guard let url = url else { return }
        self.kf.setImage(with: URL(string: url))
    }
    
    /// 设置为可点击放大
    func setScopeImages(_ urls: [String], index: Int) {
        self.isUserInteractionEnabled = true
        var button: UIButton?
        self.subviews.forEach {
            if let b = $0 as? UIButton {
                button = b
            }
        }
        if button == nil { button = UIButton() }
        guard let b = button else { return }
        if !(self.subviews.contains(b)) {
            self.addSubview(b)
            b.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            b.addTarget(self, action: #selector(UIImageView.onClickScopeButton), for: .touchUpInside)
        }
        self.scopeImageURLs = urls
        self.scopeImageIndex = index
    }
}


var ScopeImageIndexKey: Void?
var ScopeImageURLsKey: Void?

extension UIImageView {
    
    var scopeImageIndex: Int {
        get {
            return objc_getAssociatedObject(self, &ScopeImageIndexKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &ScopeImageIndexKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var scopeImageURLs: [String]? {
        get {
            return objc_getAssociatedObject(self, &ScopeImageURLsKey) as? [String]
        }
        set {
            objc_setAssociatedObject(self, &ScopeImageURLsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func onClickScopeButton() {
        if let urls = scopeImageURLs {
            let photos = urls.map { SKPhoto.photoWithImageURL($0) }
            let b = SKPhotoBrowser.init(photos: photos, initialPageIndex: scopeImageIndex)
            UIApplication.shared.topViewController().present(b, animated: true, completion: nil)
        }
    }
}
