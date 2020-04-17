//
//  OrderEnum.swift
//  Petrel
//
//  Created by wangwenjie on 2020/4/15.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation

enum OrderStatusType {
    /// 未付款 /待支付
    case obligation
    /// 待发货
    case undeliver
    /// 待收货
    case unreceive
    /// 已完成
    case complete
    /// 已关闭
    case close
    
    var statusStr: String {
        switch self {
        case .obligation:
            return "未付款"
        case .undeliver:
            return "待发货"
        case .unreceive:
            return "待收货"
        case .complete:
            return "已完成"
        case .close:
            return "已关闭"
        }
    }
}


enum OrderOperateType {
    case batch
    case single
}
