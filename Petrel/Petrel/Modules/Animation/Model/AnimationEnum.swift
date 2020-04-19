//
//  AnimationEnum.swift
//  Petrel
//
//  Created by wangwenjie on 2020/4/19.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation

enum AnimationType {
    case scale
    case rotation
    case move
    case moveSpring
    case alpha
    case fall
    case shake
    case overTurn
    case toTop
    case springList
    case shrinkToTop
    case layDown
    case rote
}

extension AnimationType {
    var title: String {
        switch self {
        case .scale:
            return "缩放"
        case .rotation:
            return "旋转"
        case .move:
            return "移动"
        case .moveSpring:
            return "弹簧移动"
        case .alpha:
            return "透明度"
        case .fall:
            return "下坠"
        case .shake:
            return "震动"
        case .overTurn:
            return "翻转"
        case .toTop:
            return "上升"
        case .rote:
            return "旋转"
        case .springList:
            return "弹簧列表"
        case .shrinkToTop:
            return "收缩至顶"
        case .layDown:
            return "掉落"
        }
    }
}
