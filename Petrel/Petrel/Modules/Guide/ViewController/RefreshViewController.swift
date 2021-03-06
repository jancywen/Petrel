//
//  RefreshViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/29.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh

class RefreshViewController: UIViewController {
    
    
    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: view.frame, style: .plain)
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        let label = FPSLabel(frame: .zero)
        self.view.addSubview(label)
        label.center = view.center
        
        self.tableView.mj_header = MJRefreshNormalHeader()
        let footer = MJRefreshAutoStateFooter()
        footer.setTitle("-- NO MORE DATA --", for: .noMoreData)
        self.tableView.mj_footer = footer
        
        let viewModel = RefreshViewModel(
            input: (headerRefresh: self.tableView.mj_header!.rx.refreshing.asDriver(),
                    footerRefresh: self.tableView.mj_footer!.rx.refreshing.asDriver()),
            dependency: (disposeBag: disposeBag, networkService: NetworkService()))
        
        viewModel.tableData.asDriver().drive(tableView.rx.items) { (tableView, row, elemet) in
            let cell = tableView.dequeueCell(UITableViewCell.self)
            cell?.textLabel?.text = "\(row) \(elemet)"
            return cell!
        }.disposed(by: disposeBag)
        
        viewModel.endHeaderRefreshing.drive(self.tableView.mj_header!.rx.endRefreshing).disposed(by: disposeBag)
        viewModel.endHeaderRefreshing.drive(onNext: { (_) in
            self.tableView.mj_footer?.resetNoMoreData()
            }).disposed(by: disposeBag)
        
        viewModel.endFooterRefreshingWithState
            .drive(self.tableView.mj_footer!.rx.endRefreshingWithState)
            .disposed(by: disposeBag)
        
    }
    
}
