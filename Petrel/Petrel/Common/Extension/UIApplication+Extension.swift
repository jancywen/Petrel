//
//  UIApplication+Extension.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/30.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation

extension UIApplication {
    /// 版本号
    func version() ->String {
        guard let info = Bundle.main.infoDictionary else { return "版本未知" }
        if let version = info["CFBundleShortVersionString"] as? String {
            return version
        }
        return "版本未知"
    }
    
    /// 栈顶控制器
    func topViewController() -> UIViewController {
        return topVCWithRootVC((self.windows.first?.rootViewController)!)
    }
    
    private func topVCWithRootVC(_ r: UIViewController) -> UIViewController {
        if let tab = r as? UITabBarController {
            return topVCWithRootVC(tab.selectedViewController!)
        } else if let navi = r as? UINavigationController {
            return topVCWithRootVC(navi.visibleViewController!)
        } else if let presented = r.presentedViewController {
            return topVCWithRootVC(presented)
        } else {
            return r
        }
    }
}
