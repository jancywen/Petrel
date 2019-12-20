//
//  SettlementViewModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources


class SettlementViewModel {
    
    let dataSource = BehaviorRelay<[SettlementSectionModel]>(value: [])

//    var model = SettlementModel()
    var settle: Driver<SettlementModel>
    
    init(goods: GoodsModel, dependency: (disposeBag: DisposeBag, service: AddressService)) {
        
                
//        let data: [SettlementSectionModel] = [
//            .address(title: "", items: [.address(nil)]),
//            .goods(title: "", items: [.shop, .goods]),
//            .totale(title: "",
//                    items: [.subtotal(count: "共1件商品", price: "¥2.50"),
//                            .single(title: "发票", content: "不开发票", accessory: true)]),
//            .ticket(title: "单笔订单仅可使用一张优惠券",
//                    items: [.single(title: "平台优惠券", content: "不可用", accessory: true),
//                            .single(title: "平台优惠券", content: "不可用", accessory: true),
//                            .single(title: "平台优惠券", content: "不可用", accessory: true),
//                            .note(title: "买家留言", content: ""),
//                            .single(title: "运费", content: "包邮", accessory: false),
//                            .card(title: "购物卡:0.00元,可抵扣0.00元", switch: false)])
//        ]
//
//        dataSource.accept(data)
        
        let addressInfo = dependency.service.queryAddress().map{$0.filter{$0.isDefault}}.asDriver(onErrorJustReturn: [])
        
        settle = Driver.combineLatest(addressInfo, addressInfo) { address1, address2 in
            var preModel = SettlementModel()
            preModel.goods = goods
            if let address = address1.first {
                preModel.address = address
            }
            return preModel
        }
        
        let someObser = dependency.service.simpleAddress()
        let some = dependency.service.simple()
        Driver.combineLatest(someObser,some) { so, s in
            so+s
        }.drive(onNext: { [weak self](s) in
            let settlemodel = SettlementModel()
            if let data = self?.configData(settlemodel) {
                self?.dataSource.accept(data)
            }
        }).disposed(by: dependency.disposeBag)
        
        settle.drive(onNext: { [weak self](settlemodel) in
            if let data = self?.configData(settlemodel) {
                self?.dataSource.accept(data)
            }
        }).disposed(by: dependency.disposeBag)
    }
    
    func configData(_ model: SettlementModel) -> [SettlementSectionModel] {
        return [
            .address(title: "", items: [.address(model.address)]),
            .goods(title: "", items: [.shop, .goods]),
            .totale(title: "",
                    items: [.subtotal(count: "共1件商品", price: "¥2.50"),
                            .single(title: "发票", content: "不开发票", accessory: true)]),
            .ticket(title: "单笔订单仅可使用一张优惠券",
                    items: [.single(title: "平台优惠券", content: "不可用", accessory: true),
                            .single(title: "平台优惠券", content: "不可用", accessory: true),
                            .single(title: "平台优惠券", content: "不可用", accessory: true),
                            .note(title: "买家留言", content: ""),
                            .single(title: "运费", content: "包邮", accessory: false),
                            .card(title: "购物卡:0.00元,可抵扣0.00元", switch: false)])
        ]
    }
    
}


enum SettlementSectionModel {
    case address(title: String, items: [SettlementSectionItem])
    case goods(title: String, items:[SettlementSectionItem])
    case totale(title: String, items:[SettlementSectionItem])
    case ticket(title: String, items: [SettlementSectionItem])
}


enum SettlementSectionItem {
    case address(AddressModel?)
    case shop
    case goods
    case subtotal(count: String, price: String)
    case single(title: String, content: String, accessory: Bool)
    case note(title: String, content: String)
    case card(title:String, switch: Bool)
}

extension SettlementSectionModel:SectionModelType {
    typealias Item = SettlementSectionItem

    var items: [SettlementSectionItem] {
        switch self {
        case .address(title: _, items: let items):
            return items.map{$0}
        case .goods(title: _, items: let items):
            return items.map{$0}
        case .totale(title: _, items: let items):
            return items.map{$0}
        case .ticket(title: _, items: let items):
            return items.map{$0}
        }
    }
    
    init(original: SettlementSectionModel, items: [SettlementSectionItem]) {
        switch original {
        case let .address(title: title, items: _):
            self = .address(title: title, items: items)
        case let .goods(title: title, items: _):
            self = .goods(title: title, items: items)
        case let .totale(title: title, items: _):
            self = .totale(title: title, items: items)
        case let .ticket(title: title, items: _):
            self = .ticket(title: title, items: items)
        }
    }
}

extension SettlementSectionModel {
    var title: String {
        switch self {
        case .address(title: let title, items: _):
            return title
        case .goods(title: let title, items: _):
            return title
        case let .totale(title: title, items: _):
            return title
        case let .ticket(title: title, items: _):
            return title
        }
    }
    var headerHeight: CGFloat {
        switch self {
        case .ticket:
            return 30
        default:
            return 0
        }
    }
    var footerHeight: CGFloat {
        switch self {
        case .goods:
            return 8
        default:
            return 0
        }
    }
}

extension SettlementSectionItem {
    var cellHeight: CGFloat {
        switch self {
        case .address:
            return 70
        case .goods:
            return 90
        case .note:
            return 120
        default:
            return 50
        }
    }
}



struct SettlementModel {
    var address: AddressModel?
    var goods: GoodsModel?
}
