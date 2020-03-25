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
import SwiftyJSON

enum ItemType {
    case douban
    case github
    case signup
    case refresh
    case upload
    case settlement
    case goodsDetail
    case ijk
    case realm
    case url
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
        case .goodsDetail:
            return "商品详情"
        case .ijk:
            return "ijk播放器"
        case .realm:
            return "realm数据库"
        case .url:
            return "URLNavigator"
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
                .settlement,
                .goodsDetail,
                .ijk,
                .realm,
                .url ]
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
            case .goodsDetail:
                let detail = GoodsDetailViewController(goodsId: "")
                detail.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(detail, animated: true)
            case .ijk:
                let ijk = IJKMediaViewController()
                ijk.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(ijk, animated: true)
            case .realm:
                let realm = RealmViewController()
                realm.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(realm, animated: true)
            case .url:
                ///无参数
//                navigator.push("petrel://douban")
                /// 单参数
                
                /// 多个参数
                navigator.present("petrel://multi?name=LiLei&score=59")
                /// 模型
//                let channel = Channel(jsonData: JSON(parseJSON: "{\"name\":\"Hally\"}"))
//                if let json = channel?.valueString  {
//                    navigator.push("petrel://nav/\(json)")
//                }
                
                /// any
                let channel = Channel(jsonData: JSON(parseJSON: "{\"name\":\"Hally\"}"))
                navigator.push("petrel://any", context: channel as Any)
                /// 打开网页
//                navigator.present("https://baidu.com")
                
                /// 弹框
//                navigator.open("petrel://alert?title=Hello&message=World")
                break
            }
            }).disposed(by: disposeBag)
        
    }


}

