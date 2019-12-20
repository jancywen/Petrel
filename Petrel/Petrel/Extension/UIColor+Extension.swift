//
//  UIColor+Extension.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit

extension UIColor {
    /// 用16进制的Int类型 创建UIColor
    @objc convenience init(_ hex: UInt32, alpha: CGFloat = 1.0) {
        let r = (CGFloat((hex & 0xFF0000) >> 16)) / 255.0
        let g = (CGFloat((hex & 0xFF00) >> 8)) / 255.0
        let b = (CGFloat((hex & 0xFF))) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /// 用16进制的String类型 创建UIColor (支持0x开头和#开头)
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var newHex = hex
        if newHex.starts(with: "#") {
            newHex = newHex.replacingOccurrences(of: "#", with: "0x")
        }
        let scanner = Scanner(string: newHex)
        scanner.scanLocation = 0
        var rgbValue:UInt32 = 0
        scanner.scanHexInt32(&rgbValue)
        
        let r = (CGFloat((rgbValue & 0xFF0000) >> 16)) / 255.0
        let g = (CGFloat((rgbValue & 0xFF00) >> 8)) / 255.0
        let b = (CGFloat((rgbValue & 0xFF))) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

