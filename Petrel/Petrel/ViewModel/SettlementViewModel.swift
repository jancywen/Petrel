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

    var model:SettlementModel {
        didSet {
            settleRelay.accept(model)
        }
    }
    var settleRelay: BehaviorRelay<SettlementModel>
    
    init(goods: GoodsModel,
         dependency: (
        disposeBag: DisposeBag,
        addressService: AddressService,
        couponService: CouponService)) {
        
        
        var preModel = SettlementModel()
        preModel.goods = goods
        model = preModel
        
        settleRelay = BehaviorRelay<SettlementModel>(value: model)
        settleRelay.map{self.configData($0)}
            .asDriver(onErrorJustReturn: [])
            .drive(dataSource)
            .disposed(by: dependency.disposeBag)
        
        dependency.addressService.queryAddress()
            .map{$0.filter{$0.isDefault}}
            .asObservable()
            .subscribe(onNext: { (addresses) in
            if let address = addresses.first {
                self.model.address = address
            }
        }).disposed(by: dependency.disposeBag)
        
        dependency.couponService.queryAvailableCoupon()
            .asObservable()
            .subscribe(onNext: { (coupons) in
            self.model.coupons = coupons
        }).disposed(by: dependency.disposeBag)

    }
    
    func configData(_ model: SettlementModel) -> [SettlementSectionModel] {
        
        let inv_str = model.invoice == nil ? "不开发票" : "个人发票"
        let available = model.coupons?.count ?? 0 > 0
        let cou_str = available ? (model.coupon == nil ? "请选择" : "满50减10") : "不可用"
        let fre_str = model.goods?.freight == 0 ? "包邮" : "¥\(model.goods?.freight ?? 0.0)"
        return [
            .address(title: "", items: [.address(model.address)]),
            .goods(title: "", items: [.shop(model.goods?.shop), .goods(model.goods)]),
            .totale(title: "",
                    items: [.subtotal(count: "共\(model.goods?.count ?? 0)件商品", price: "¥\(model.goods?.price ?? "0.00")"),
                            .invoice(title: "发票", content: inv_str, accessory: true)]),
            .ticket(title: "",
                    items: [.coupon(title: "优惠券", content: cou_str, accessory: available),
                        .note(title: "买家留言", content: model.remark),
                        .single(title: "运费", content: fre_str, accessory: false),
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
    case shop(Shop?)
    case goods(GoodsModel?)
    case subtotal(count: String, price: String)
    case single(title: String, content: String, accessory: Bool)
    case invoice(title: String, content: String, accessory: Bool)
    case coupon(title: String, content: String, accessory: Bool)
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
        default:
            return 0
        }
    }
    var footerHeight: CGFloat {
        switch self {
        case .goods, .totale:
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
    var coupons: [CouponModel]?
    var coupon: CouponModel?
    var invoice: Invoice?
    var remark: String = ""
}
