//
//  TokenViewController.swift
//  Petrel
//
//  Created by captain on 2020/7/17.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class TokenViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    lazy var viewModel = TokenViewModel(GoodsService(), disposeBag)
    
    var dataSource:RxTableViewSectionedReloadDataSource<TokenSectionModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = sectionDataSource()
        self.dataSource = dataSource
        
        self.viewModel.dataSource
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        TokenAPI.token.request { (result) in
            switch result {
            case let .success(response):
                break
            case let .failure(error):
                print(error)
            }
        }
        
    }


    func sectionDataSource()-> RxTableViewSectionedReloadDataSource<TokenSectionModel> {
        return RxTableViewSectionedReloadDataSource<TokenSectionModel>(configureCell: { (_, tv, ip, item) -> UITableViewCell in
            switch item {
            case .product(product: let product):
                let cell = tv.dequeueCell(TokenProductCell.self) as! TokenProductCell
                cell.product = product
                return cell
            case .market(market: let market):
                let cell = tv.dequeueCell(TokenMarketCell.self) as! TokenMarketCell
                cell.market = market
                return cell
            }
        }, titleForHeaderInSection: { (ds, section) -> String? in
            switch ds[section] {
            case .market(title: let title, items: _):
                return title
            case .product(title: let title, items: _):
                return title
            }
        })
    }
    
}

extension TokenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 38))
        view.backgroundColor = .red
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}
