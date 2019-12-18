//
//  MineServiceModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/12.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya_SwiftyJSONMapper

enum MineServiceType: String {
    /// 待支付
    case unpaid = "unpaid"
    /// 待发货
    case unsend = "unsend"
    /// 待收货
    case unreceive = "unreceive"
    /// 待评价
    case unevaluate = "unevaluate"
    /// 退款售后
    case aftermarket = "aftermarket"
    
    /// 优惠券
    case coupon = "coupon"
    /// 购物卡
    case shoppingcard = "shoppingcard"
    /// 我的客服
    case server = "server"
    /// 邀请码
    case code = "code"
    /// 拼团
    case group = "group"
    /// 收入
    case income = "income"
    /// 充值中心
    case recharge = "recharge"
    ///
    /// 店铺管理
    case shop = "shop"
    /// 商品管理
    case goods = "goods"
    /// 店铺分享
    case shareshop = "shareshop"
    /// 收入分享
    case shareincome = "shareincome"
    /// 我的粉丝
    case fans = "fans"
    /// 邀请粉丝
    case invitefans = "invitefans"
    /// 商学院
    case school = "shool"
    /// 公告
    case notice = "notice"
    /// 名片
    case businesscard = "businesscard"
    
    var title:String {
        switch self {
        case .unpaid:
            return ""
        case .unsend:
            return ""
        case .unreceive:
            return ""
        case .unevaluate:
            return ""
        case .aftermarket:
            return ""
        case .coupon:
            return ""
        case .shoppingcard:
            return ""
        case .server:
            return ""
        case .code:
            return ""
        case .group:
            return ""
        case .income:
            return ""
        case .recharge:
            return ""
        case .shop:
            return ""
        case .goods:
            return ""
        case .shareshop:
            return ""
        case .shareincome:
            return ""
        case .fans:
            return ""
        case .invitefans:
            return ""
        case .school:
            return ""
        case .notice:
            return ""
        case .businesscard:
            return ""
        }
    }
    
    var image: String {
        switch self {
        case .unpaid:
            return ""
        case .unsend:
            return ""
        case .unreceive:
            return ""
        case .unevaluate:
            return ""
        case .aftermarket:
            return ""
        case .coupon:
            return ""
        case .shoppingcard:
            return ""
        case .server:
            return ""
        case .code:
            return ""
        case .group:
            return ""
        case .income:
            return ""
        case .recharge:
            return ""
        case .shop:
            return ""
        case .goods:
            return ""
        case .shareshop:
            return ""
        case .shareincome:
            return ""
        case .fans:
            return ""
        case .invitefans:
            return ""
        case .school:
            return ""
        case .notice:
            return ""
        case .businesscard:
            return ""
        }
    }
}

