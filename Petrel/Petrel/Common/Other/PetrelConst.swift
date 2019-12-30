//
//  PetrelConst.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/30.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation

/// 屏幕宽度
public let ScreenWidth = UIScreen.main.bounds.width

/// 屏幕高度
public let ScreenHeight = UIScreen.main.bounds.height

/// 是否有刘海
public let isIPhoneX = ScreenHeight >= 812

public let isSmallIPhone = ScreenWidth < 375

/// 顶部状态栏高度
public let TopSafeAreaHeight: CGFloat = isIPhoneX ? 44 : 20

/// 导航栏高度
public let NaviBarHeight: CGFloat = isIPhoneX ? 88 : 64

/// 底部安全高度
public let BottomSafeAreaHeight: CGFloat = isIPhoneX ? 34 : 0

/// 全局栈顶控制器toast
public func showTextOnTopViewController(text: String) {
    
//    UIApplication.shared.nm.topViewController().view.showToastText(text)
}
