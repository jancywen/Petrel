//
//  UIFont+Extension.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit

public extension UIFont {
    enum NMFontType {
        case regular
        case medium
        case light
        case semiBlod
    }
    
    convenience init(type: NMFontType, size: CGFloat) {
        let fontString: String
        switch type {
        case .regular:
            fontString = "PingFangSC-Regular"
        case .medium:
            fontString = "PingFangSC-Medium"
        case .light:
            fontString = "PingFangSC-Light"
        case .semiBlod:
            fontString = "PingFangSC-Semibold"
        }
        self.init(name: fontString, size: size)!
    }
    
    
    // MARK: - 常用字体
    @objc static let f8 = UIFont.systemFont(ofSize: 8)
    @objc static let f9 = UIFont.systemFont(ofSize: 9)
    @objc static let f10 = UIFont.systemFont(ofSize: 10)
    @objc static let f11 = UIFont.systemFont(ofSize: 11)
    @objc static let f12 = UIFont.systemFont(ofSize: 12)
    @objc static let f13 = UIFont.systemFont(ofSize: 13)
    @objc static let f14 = UIFont.systemFont(ofSize: 14)
    @objc static let f15 = UIFont.systemFont(ofSize: 15)
    @objc static let f16 = UIFont.systemFont(ofSize: 16)
    @objc static let f17 = UIFont.systemFont(ofSize: 17)
    @objc static let f18 = UIFont.systemFont(ofSize: 18)
    @objc static let f20 = UIFont.systemFont(ofSize: 20)
    @objc static let f22 = UIFont.systemFont(ofSize: 22)
    @objc static let f24 = UIFont.systemFont(ofSize: 24)
    @objc static let f26 = UIFont.systemFont(ofSize: 26)
    @objc static let f28 = UIFont.systemFont(ofSize: 28)
    @objc static let f30 = UIFont.systemFont(ofSize: 30)
    @objc static let f32 = UIFont.systemFont(ofSize: 32)
    @objc static let f34 = UIFont.systemFont(ofSize: 34)
    @objc static let f36 = UIFont.systemFont(ofSize: 36)
    @objc static let f40 = UIFont.systemFont(ofSize: 40)
    @objc static let f56 = UIFont.systemFont(ofSize: 56)
    @objc static let f72 = UIFont.systemFont(ofSize: 72)
    
    @objc static let b8 = UIFont.boldSystemFont(ofSize: 8)
    @objc static let b9 = UIFont.boldSystemFont(ofSize: 9)
    @objc static let b10 = UIFont.boldSystemFont(ofSize: 10)
    @objc static let b11 = UIFont.boldSystemFont(ofSize: 11)
    @objc static let b12 = UIFont.boldSystemFont(ofSize: 12)
    @objc static let b13 = UIFont.boldSystemFont(ofSize: 13)
    @objc static let b14 = UIFont.boldSystemFont(ofSize: 14)
    @objc static let b15 = UIFont.boldSystemFont(ofSize: 15)
    @objc static let b16 = UIFont.boldSystemFont(ofSize: 16)
    @objc static let b17 = UIFont.boldSystemFont(ofSize: 17)
    @objc static let b18 = UIFont.boldSystemFont(ofSize: 18)
    @objc static let b20 = UIFont.boldSystemFont(ofSize: 20)
    @objc static let b22 = UIFont.boldSystemFont(ofSize: 22)
    @objc static let b24 = UIFont.boldSystemFont(ofSize: 24)
    @objc static let b26 = UIFont.boldSystemFont(ofSize: 26)
    @objc static let b28 = UIFont.boldSystemFont(ofSize: 28)
    @objc static let b30 = UIFont.boldSystemFont(ofSize: 30)
    @objc static let b32 = UIFont.boldSystemFont(ofSize: 32)
    @objc static let b34 = UIFont.boldSystemFont(ofSize: 34)
    @objc static let b36 = UIFont.boldSystemFont(ofSize: 36)
    @objc static let b40 = UIFont.boldSystemFont(ofSize: 40)
    @objc static let b56 = UIFont.boldSystemFont(ofSize: 56)
    @objc static let b72 = UIFont.boldSystemFont(ofSize: 72)
}

@available(iOS 8.2, *)
extension UIFont {
    @objc static let m8 = UIFont.systemFont(ofSize: 8, weight: .medium)
    @objc static let m9 = UIFont.systemFont(ofSize: 9, weight: .medium)
    @objc static let m10 = UIFont.systemFont(ofSize: 10, weight: .medium)
    @objc static let m11 = UIFont.systemFont(ofSize: 11, weight: .medium)
    @objc static let m12 = UIFont.systemFont(ofSize: 12, weight: .medium)
    @objc static let m13 = UIFont.systemFont(ofSize: 13, weight: .medium)
    @objc static let m14 = UIFont.systemFont(ofSize: 14, weight: .medium)
    @objc static let m15 = UIFont.systemFont(ofSize: 15, weight: .medium)
    @objc static let m16 = UIFont.systemFont(ofSize: 16, weight: .medium)
    @objc static let m17 = UIFont.systemFont(ofSize: 17, weight: .medium)
    @objc static let m18 = UIFont.systemFont(ofSize: 18, weight: .medium)
    @objc static let m20 = UIFont.systemFont(ofSize: 20, weight: .medium)
    @objc static let m22 = UIFont.systemFont(ofSize: 22, weight: .medium)
    @objc static let m24 = UIFont.systemFont(ofSize: 24, weight: .medium)
    @objc static let m26 = UIFont.systemFont(ofSize: 26, weight: .medium)
    @objc static let m28 = UIFont.systemFont(ofSize: 28, weight: .medium)
    @objc static let m30 = UIFont.systemFont(ofSize: 30, weight: .medium)
    @objc static let m32 = UIFont.systemFont(ofSize: 32, weight: .medium)
    @objc static let m34 = UIFont.systemFont(ofSize: 34, weight: .medium)
    @objc static let m36 = UIFont.systemFont(ofSize: 36, weight: .medium)
    @objc static let m40 = UIFont.systemFont(ofSize: 40, weight: .medium)
    @objc static let m56 = UIFont.systemFont(ofSize: 56, weight: .medium)
    @objc static let m72 = UIFont.systemFont(ofSize: 72, weight: .medium)
    
    
    
    @objc static let s8 = UIFont.systemFont(ofSize: 8, weight: .semibold)
    @objc static let s9 = UIFont.systemFont(ofSize: 9, weight: .semibold)
    @objc static let s10 = UIFont.systemFont(ofSize: 10, weight: .semibold)
    @objc static let s11 = UIFont.systemFont(ofSize: 11, weight: .semibold)
    @objc static let s12 = UIFont.systemFont(ofSize: 12, weight: .semibold)
    @objc static let s13 = UIFont.systemFont(ofSize: 13, weight: .semibold)
    @objc static let s14 = UIFont.systemFont(ofSize: 14, weight: .semibold)
    @objc static let s15 = UIFont.systemFont(ofSize: 15, weight: .semibold)
    @objc static let s16 = UIFont.systemFont(ofSize: 16, weight: .semibold)
    @objc static let s17 = UIFont.systemFont(ofSize: 17, weight: .semibold)
    @objc static let s18 = UIFont.systemFont(ofSize: 18, weight: .semibold)
    @objc static let s20 = UIFont.systemFont(ofSize: 20, weight: .semibold)
    @objc static let s22 = UIFont.systemFont(ofSize: 22, weight: .semibold)
    @objc static let s24 = UIFont.systemFont(ofSize: 24, weight: .semibold)
    @objc static let s26 = UIFont.systemFont(ofSize: 26, weight: .semibold)
    @objc static let s28 = UIFont.systemFont(ofSize: 28, weight: .semibold)
    @objc static let s30 = UIFont.systemFont(ofSize: 30, weight: .semibold)
    @objc static let s32 = UIFont.systemFont(ofSize: 32, weight: .semibold)
    @objc static let s34 = UIFont.systemFont(ofSize: 34, weight: .semibold)
    @objc static let s36 = UIFont.systemFont(ofSize: 36, weight: .semibold)
    @objc static let s40 = UIFont.systemFont(ofSize: 40, weight: .semibold)
    @objc static let s56 = UIFont.systemFont(ofSize: 56, weight: .semibold)
    @objc static let s72 = UIFont.systemFont(ofSize: 72, weight: .semibold)
    
}
