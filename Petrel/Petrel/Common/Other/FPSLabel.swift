//
//  FPSLabel.swift
//  Petrel
//
//  Created by wangwenjie on 2020/1/1.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation

class WeakProxy: NSObject {
    weak var target: NSObjectProtocol?
    
    init(target: NSObjectProtocol) {
        self.target = target
        super.init()
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
    
        return (target?.responds(to: aSelector) ?? false) || super.responds(to: aSelector)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
}

class FPSLabel: UILabel {
    var link: CADisplayLink!
    /// 记录方法执行次数
    var count: Int = 0
    /// 记录上次方法执行的时间, 通过link.timestamp - _lastTime计算时间间隔
    var lastTime: TimeInterval = 0
    var _font: UIFont!
    var _subFont: UIFont!
    fileprivate let defaultSize = CGSize(width: 55, height: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame.size.width == 0 && frame.size.height == 0 {
            self.frame.size = defaultSize
        }
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = NSTextAlignment.center
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        _font = UIFont(name: "Menlo", size: 14)
        if _font != nil {
            _subFont = UIFont(name: "Menlo", size: 4)
        }else {
            _font = UIFont(name: "Courier", size: 14)
            _subFont = UIFont(name: "Courier", size: 4)
        }
        
        link = CADisplayLink(target: WeakProxy.init(target: self), selector: #selector(tick(link:)))
        link.add(to: RunLoop.main, forMode: .common)
    }
    
    /// CADisplayLink 刷新执行的方法
    @objc func tick(link: CADisplayLink) {
        guard lastTime != 0 else {
            lastTime = link.timestamp
            return
        }
        
        count += 1
        let timePassed = link.timestamp - lastTime
        
        /// 时间大于等于1秒计算一次, 也就是FPSLabel刷新的间隔, 不要太频繁刷新
        guard timePassed >= 1 else {
            return
        }
        lastTime = link.timestamp
        let fps = Double(count) / timePassed
        count = 0
        
        let progress = fps / 60.0
        let color = UIColor(hue: CGFloat(0.27 * (progress - 0.2)), saturation: 1, brightness: 0.9, alpha: 1)
        
        let text = NSMutableAttributedString(string: "\(Int(round(fps))) FPS")
        text.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: text.length - 3))
        text.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: text.length - 3, length: 3))
        text.addAttribute(.font, value: _font! , range: NSRange(location: 0, length: text.length))
        text.addAttribute(.font, value: _subFont!, range: NSRange(location: text.length - 4, length: 1))
        self.attributedText = text
    }
    
    deinit {
        link.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
