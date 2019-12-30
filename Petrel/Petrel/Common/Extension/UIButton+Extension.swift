//
//  UIButton+Extension.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/30.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation

public extension UIButton {
    /// UIButton的快速创建方法，支持苹方
    convenience init(title: String, textColor: UIColor, size: CGFloat, fontType: UIFont.NMFontType) {
        self.init(title: title, textColor: textColor, font: UIFont(type: fontType, size: size))
    }
    
    /// UIButton的快速创建方法，支持任意字体
    convenience init(title: String, textColor: UIColor, font: UIFont) {
        self.init(type: .custom)
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
    }
}


public extension UIButton {
    // 调整水平间距（图片,文字)
    func horizontalCenterImageAndTitlte(with spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
    }
    
    // 调整水平间距（文字, 图片)
    func horizontalCenterTitleAndImage(with spacing: CGFloat) {
        self.horizontalCenterTitleAndImage(with: spacing)
    }
    
    // 垂直居中图片文字
    func verticalCenterImageAndTitle(with spacing:CGFloat) {
        self.verticalCenterImageAndTitle(with: spacing)
    }
    
    /// 为Button设置网络图片
    func setWebImage(_ url: String, for state: UIControl.State) {
        self.kf.setImage(with: URL(string: url), for: .normal)
    }
    
    /// 为button添加block功能
    func add(action:@escaping  BtnAction ,for controlEvents: UIControl.Event) {
        let eventStr = NSString.init(string: String.init(describing: controlEvents.rawValue))
        if let actions = self.actionDic {
            actions.setObject(action, forKey: eventStr)
            self.actionDic = actions
        }else{
            self.actionDic = NSMutableDictionary.init(object: action, forKey: eventStr)
        }
        switch controlEvents {
        case .touchUpInside:
            self.addTarget(self, action: #selector(self.touchUpInSideBtnAction), for: .touchUpInside)
        case .touchUpOutside:
            self.addTarget(self, action: #selector(self.touchUpOutsideBtnAction), for: .touchUpOutside)
        default:
            print("暂时没有添加这些block功能")
            return
        }
    }
}

private struct AssociatedKeys{
    static var actionKey = "actionKey"
}

var verticalImageTitleSpacingKey: Void?
let NMImageTitleSpacingNone:CGFloat = 9999.9999
public typealias BtnAction = (UIButton)->()

fileprivate extension UIButton {
    
    @objc dynamic var actionDic: NSMutableDictionary? {
        set{
            objc_setAssociatedObject(self,&AssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let dic = objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? NSDictionary{
                return NSMutableDictionary.init(dictionary: dic)
            }
            return nil
        }
    }
    
    @objc fileprivate func touchUpInSideBtnAction(btn: UIButton) {
        if let actionDic = self.actionDic  {
            if let touchUpInSideAction = actionDic.object(forKey: String.init(describing: UIControl.Event.touchUpInside.rawValue)) as? BtnAction{
                touchUpInSideAction(self)
            }
        }
    }
    
    @objc fileprivate func touchUpOutsideBtnAction(btn: UIButton) {
        if let actionDic = self.actionDic  {
            if let touchUpOutsideBtnAction = actionDic.object(forKey:   String.init(describing: UIControl.Event.touchUpOutside.rawValue)) as? BtnAction{
                touchUpOutsideBtnAction(self)
            }
        }
    }
}
