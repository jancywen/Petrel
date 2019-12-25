//
//  GoodsDetailViewModel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation

import RxDataSources
import RxCocoa
import RxSwift

final class GoodsDetailViewModel {
    
    let dataSource = BehaviorRelay<[GoodsDetailSectionModel]>(value: [])
    var goodsInfo: Goods {
        didSet {
            goodsRelay.accept(goodsInfo)
        }
    }
    
    var goodsRelay: BehaviorRelay<Goods>
    
    
    init(goodsId: String, dependency:(goodsNetWork: GoodsService, disposeBag: DisposeBag) ) {
        
        goodsInfo = Goods(jsonData: "{}")!
        goodsInfo.id = goodsId
        goodsRelay = BehaviorRelay(value: goodsInfo)
        
        dependency.goodsNetWork.goodsDetailInfo(goodsId).subscribe(onNext: { goods in
            self.goodsInfo = goods
        }).disposed(by: dependency.disposeBag)
        
//        dependency.goodsNetWork.goodsDetailInfo(goodsId)
//            .asDriver(onErrorJustReturn: Goods(jsonData: "{}")!)
//            .drive(goodsRelay)
//            .disposed(by: dependency.disposeBag)
                
        goodsRelay.map { self.configData($0)}
            .asDriver(onErrorJustReturn: [])
            .drive(dataSource)
            .disposed(by: dependency.disposeBag)
    }
    
    
    func configData(_ goods: Goods) -> [GoodsDetailSectionModel] {
        return [.baseInfo(items: [.banner,
                                  .content]),
                .available(items: [.coupon,
                                   .sku,
                                   .server]),
                .comment(items: [.comment])]
    }
    
}




enum GoodsDetailSectionModel {
    case baseInfo(items: [GoodsDetailSectionItem])
    case available(items: [GoodsDetailSectionItem])
    case comment(items:[GoodsDetailSectionItem])
    case goodsDetail(items: [GoodsDetailSectionItem])
}

extension GoodsDetailSectionModel: SectionModelType {
    typealias Item = GoodsDetailSectionItem
    
    var items: [GoodsDetailSectionItem] {
        switch self {
        case .baseInfo(let items):
            return items.map{$0}
        case .available(let items):
            return items.map{$0}
        case .comment(let items):
            return items.map{$0}
        case .goodsDetail(let items):
            return items.map{$0}
        }
    }
    init(original: Self, items: [Self.Item]) {
        switch original {
        case .baseInfo(let items):
            self = .baseInfo(items: items)
        case .available(let items):
            self = .available(items: items)
        case .comment(let items):
            self = .comment(items: items)
        case .goodsDetail(let items):
            self = .goodsDetail(items: items)
        }
    }
}

extension GoodsDetailSectionModel {
    var title: String {
        return ""
    }
    var headerHeight: CGFloat {
        return 0
    }
    var footerHeight: CGFloat {
        switch self {
        case .goodsDetail:
            return 0
        default:
            return 5
        }
    }
}

enum GoodsDetailSectionItem {
    case banner
    case content
    case coupon
    case sku
    case server
    case comment
    case detail
}

extension GoodsDetailSectionItem {
    var cellHeight: CGFloat {
        switch self {
        case .banner:
            return 270
        case .content:
            return 270
        case .coupon:
            return 50
        case .sku:
            return 50
        case .server:
            return 50
        case .comment:
            return 100
        case .detail:
            return 100
        }
    }
}
