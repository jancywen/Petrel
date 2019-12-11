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
    case douban(String)
    case github(String)
    case signup(String)
    case refresh(String)
}


class ViewController: UIViewController {

    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    var items: Array<ItemType> {
        return [.douban("豆瓣音乐"),
                .github("GitHub"),
                .signup("验证注册"),
                .refresh("下拉刷新上提加载")]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "目录"
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
         
        Signal.just(items).asObservable().bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            switch element {
            case .douban(let title), .github(let title), .signup(let title), .refresh(let title):
                cell.textLabel?.text = title
            }
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
            }
            }).disposed(by: disposeBag)
        
    }


}

