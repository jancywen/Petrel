//
//  MineViewModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/12.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources

final class MineViewModel {
    
    let dataSource: Driver<[MineServiceSectionModel]>
    
    init() {
        dataSource = Driver.just([.order(items: [.item(.unpaid),
                                                 .item(.unsend),
                                                 .item(.unreceive),
                                                 .item(.unevaluate),
                                                 .item(.aftermarket)]),
                                  .capital(items:[.item(.coupon)]),
                                  .shop(items:[.item(.shop)])])
    }
    
    
}


enum MineServiceSectionModel {
    case order(items:[MineServiceSectionItem])
    case capital(items:[MineServiceSectionItem])
    case shop(items: [MineServiceSectionItem])
}

extension MineServiceSectionModel: SectionModelType {
    
    typealias Item = MineServiceSectionItem
    
    var items:[MineServiceSectionItem] {
        switch self {
        case .order(let items):
            return items.map{$0}
        case .capital(let items):
            return items.map{$0}
        case .shop(let items):
            return items.map{$0}
        }
    }
    
    init(original: Self, items: [MineServiceSectionItem]) {
        switch original {
        case .order(let items):
            self = .order(items: items)
        case .capital(let items):
            self = .capital(items: items)
        case .shop(let items):
            self = .shop(items: items)
        }
    }
}

extension MineServiceSectionModel {
    var title: String {
        switch self {
        case .order:
            return "我的订单"
        case .capital:
            return "我的服务"
        case .shop:
            return "店铺管理"
        }
    }
}

enum MineServiceSectionItem {
    case item(MineServiceType)
}

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
            return "待付款"
        case .unsend:
            return "待发货"
        case .unreceive:
            return "待收货"
        case .unevaluate:
            return "待评价"
        case .aftermarket:
            return "售后"
        case .coupon:
            return "优惠券"
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
            return "我的商铺"
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
            return "mine_item_card_icon"
        case .unsend:
            return "mine_item_card_icon"
        case .unreceive:
            return "mine_item_card_icon"
        case .unevaluate:
            return "mine_item_card_icon"
        case .aftermarket:
            return "mine_item_card_icon"
        case .coupon:
            return "mine_item_card_icon"
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
            return "mine_item_card_icon"
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

