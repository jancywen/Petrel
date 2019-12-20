//
//  ViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


enum ItemType {
    case douban
    case github
    case signup
    case refresh
    case upload
    case settlement
}

extension ItemType {
    var title: String {
        switch self {
        case .douban:
            return "豆瓣音乐"
        case .github:
            return "Github"
        case .signup:
            return "注册验证"
        case .refresh:
            return "下拉刷新 上提加载"
        case .upload:
            return "异步上传 排序"
        case .settlement:
            return "商品结算"
        }
    }
}

class ViewController: UIViewController {

    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    var items: Array<ItemType> {
        return [.douban,
                .github,
                .signup,
                .refresh,
                .upload,
                .settlement ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "目录"
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
         
        Signal.just(items).asObservable().bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            
            cell.textLabel?.text = element.title
            cell.accessoryType = .disclosureIndicator
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ItemType.self).subscribe(onNext: { [weak self](item) in
            switch item {
            case .douban:
                let douban = DouBanViewController()
                douban.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(douban, animated: true)
            case .github:
                let github = GitHubViewController()
                github.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(github, animated: true)
            case .signup:
                let register = RegisterViewController()
                register.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(register, animated: true)
            case .refresh:
                let refresh = RefreshViewController()
                refresh.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(refresh, animated: true)
            case .upload:
                let upload = UploadViewController()
                upload.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(upload, animated: true)
                break
            case .settlement:
                let goods = GoodsModel(jsonData: "{}")
                let settlement = SettlementViewController(goods: goods!)
                settlement.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(settlement, animated: true)
            }
            }).disposed(by: disposeBag)
        
    }


}

