//
//  SettlementViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
// 商品结算

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class SettlementViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var viewModel: SettlementViewModel
    
    var dataSource: RxTableViewSectionedReloadDataSource<SettlementSectionModel>?
    
    let disposeBag = DisposeBag()
    
    let invoice = Driver<String>.just("不开发票")
    
    
    init(goods: GoodsModel) {
        viewModel = SettlementViewModel(goods: goods,
                                        dependency: (disposeBag: disposeBag, service: AddressService()))

        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "商品结算"
        view.backgroundColor = UIColor(0xF7F7F7)
        
        
        let dataSource = SettlementViewController.dataSource()
        self.dataSource = dataSource
        self.viewModel.dataSource
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.tableFooterView = UIView()
    }
    
    

    @IBAction func onClickPayment(_ sender: Any) {
    }
    
}


extension SettlementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataSource?[indexPath]
        return item?.cellHeight ?? 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = dataSource?[section]
        return model?.headerHeight ?? 0.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let model = dataSource?[section]
        return model?.footerHeight ?? 0.0
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueHeaderFooter()
//        header?.textLabel?.font = UIFont(type: .regular, size: 14)
//        header?.textLabel?.text = dataSource?[section].title
//        header?.backgroundColor = UIColor(0xF7F7F7)
//        return header
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footer = tableView.dequeueHeaderFooter()
//        footer?.backgroundColor = UIColor(0xF7F7F7)
//        return footer
//    }
}

extension SettlementViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SettlementSectionModel> {
        return RxTableViewSectionedReloadDataSource<SettlementSectionModel>(configureCell: { (dataSource, tv, ip, item) in
            switch item {
            case .address(let model):
                let cell = tv.dequeueCell(SettlementAddressCell.self) as! SettlementAddressCell
                cell.render(model)
                return cell
            case .shop:
                let cell = tv.dequeueCell(SettlementShopCell.self)
                return cell!
            case .goods:
                let cell = tv.dequeueCell(SettlementGoodsCell.self)
                return cell!
            case .subtotal( _, _):
                let cell = tv.dequeueCell(SettlementSubtotalCell.self)
                return cell!
            case .single(_, _, _):
                let cell = tv.dequeueCell(SettlementSingleCell.self)
                return cell!
            case .note( _, _):
                let cell = tv.dequeueCell(SettlementNoteCell.self)
                return cell!
            case .card( _, _):
                let cell = tv.dequeueCell(SettlementCardCell.self)
                return cell!
            }
        },
        titleForHeaderInSection: { dataSource, section in
            return dataSource[section].title
        })
    }
}

