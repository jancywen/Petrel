//
//  UIImage+extension.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/3.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation
extension UIImage {
    func load() -> UnsafeMutableRawPointer? {
        // 1获取图片的CGImageRef
        guard let spriteImage = self.cgImage else {
            return nil
        }
        // 2 读取图片的大小
        let width = spriteImage.width
        let height = spriteImage.height
        let spriteData = calloc(width * height * 4, MemoryLayout<UInt8>.size) //rgba共4个byte
        let spriteContext = CGContext(data: spriteData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: spriteImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        // 3在CGContextRef上绘图
        spriteContext?.draw(spriteImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        return spriteData
    }
}
