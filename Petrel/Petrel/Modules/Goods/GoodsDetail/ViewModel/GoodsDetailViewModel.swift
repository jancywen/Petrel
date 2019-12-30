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
        let videoUrl = "https://vdept.bdstatic.com/546c704d313242626266737673394633/75515a414a635673/b39c042e82d994cd4c4a82d884c757dcb3ef3cc573c775341e8fbf438b7a5cea92166bb1c126fcd41e89411b01c44ac1.mp4?auth_key=1577702633-0-0-d73f481017eb6b480c14806c6586a58b"
        let pics = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577705370045&di=ade543f4d7d7c4abd47b9448a8cbcdcd&imgtype=0&src=http%3A%2F%2Fupload.art.ifeng.com%2F2015%2F1105%2F1446710350536.jpg",  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577705370043&di=0f5ed2d2828b5c41ebcc4cbc35c257b3&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F0feb91434f44454370bcac141648fbdfbec3ee7e5bfb5-ggUAcx_fw658", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577705448314&di=b614dc0d5428f6806bdc24bbfcdbd6a4&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D1525588670%2C781012550%26fm%3D214%26gp%3D0.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577705370041&di=60463adec3826432c2d9fbd5a192a804&imgtype=0&src=http%3A%2F%2Fp0.qhimgs4.com%2Ft01abad527a7e07978e.jpg"]
        return [.baseInfo(items: [.banner(videoUrl: videoUrl, picsUrls: pics),
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
    case banner(videoUrl: String, picsUrls: [String])
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
