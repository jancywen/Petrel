//
//  CouponAPI.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/21.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya


enum CouponAPI {
    /// 查询可用优惠券
    case available
    /// 查询平台优惠券
    case platform
    /// 品类
    case category
    /// 商品
    case goods
    /// 购物卡
    case card
}


extension CouponAPI: TargetType {
    var path: String {
        switch self {
        case .available:
            return "/api/coupon/available"
        case .platform:
            return "/api/coupon/platform"
        case .category:
            return "/api/coupon/category"
        case .goods:
            return "/api/coupon/goods"
        case .card:
            return "/api/coupon/card"
        }
    }
}
