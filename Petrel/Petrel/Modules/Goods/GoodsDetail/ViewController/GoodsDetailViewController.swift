//
//  GoodsDetailViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class GoodsDetailViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buyNow: UIButton!
    let viewModel: GoodsDetailViewModel
    let disposeBag = DisposeBag()
    
    var dataSource : RxTableViewSectionedReloadDataSource<GoodsDetailSectionModel>?
    
    init(goodsId: String) {
        viewModel = GoodsDetailViewModel(goodsId: goodsId,
                                         dependency: (goodsNetWork: GoodsService(),
                                                      disposeBag: disposeBag))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = sectionDataSource()
        self.dataSource = dataSource
        
        self.viewModel.dataSource
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        buyNow.rx.tap.asDriver().drive(onNext: buyNowAction).disposed(by: disposeBag)
    }

}

extension GoodsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource?[indexPath].cellHeight ?? 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataSource?[section].footerHeight ?? 0.0
    }
}
extension GoodsDetailViewController {
    func sectionDataSource() -> RxTableViewSectionedReloadDataSource<GoodsDetailSectionModel> {
        return RxTableViewSectionedReloadDataSource<GoodsDetailSectionModel>(
            configureCell:{ ds, tv, ip, item in
                switch item {
                    
                case .banner:
                    let cell = tv.dequeueCell(GoodsDetailBannerCell.self)
                    
                    return cell!
                case .content:
                    let cell = tv.dequeueCell(GoodsDetailContentCell.self)
                    return cell!
                case .coupon:
                    let cell = tv.dequeueCell(GoodsDetailCouponCell.self)
                    return cell!
                case .sku:
                    let cell = tv.dequeueCell(GoodsDetailTextCell.self)
                    return cell!
                case .server:
                    let cell = tv.dequeueCell(GoodsDetailTextCell.self)
                    return cell!
                case .comment:
                    let cell = tv.dequeueCell(GoodsDetailCommentCell.self)
                    return cell!
                case .detail:
                    let cell = tv.dequeueCell(UITableViewCell.self)
                    return cell!
                }
        })
    }
}

extension GoodsDetailViewController {
    func buyNowAction() {
        let goods = GoodsModel(jsonData: "{}")
        let settlement = SettlementViewController(goods: goods!)
        settlement.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settlement, animated: true)
    }
}
