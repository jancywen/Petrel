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
                .url,
                .segment,
                .animation,
                .metal,
                .richtext,
                .promise,
                .permissions,
                .cellAlign,
                .noData ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "目录"
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
         
        let items = Observable.just(self.items)
        items.bind(to: tableView.rx.items) { (tableView, row, element) in
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
//                let detail = GoodsDetailViewController(goodsId: "")
//                detail.hidesBottomBarWhenPushed = true
//                self?.navigationController?.pushViewController(detail, animated: true)
                
                let detail = TokenViewController()
                detail.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(detail, animated: true)
            case .ijk:
                let ijk = IJKMediaViewController()
                ijk.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(ijk, animated: true)
            case .realm:
                break
//                let realm = RealmViewController()
//                realm.hidesBottomBarWhenPushed = true
//                self?.navigationController?.pushViewController(realm, animated: true)
            case .url:
                navigator.push("petrel://urlnav")
            case .segment:
                let orderMain = OrderMainViewController()
                orderMain.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(orderMain, animated: true)
                break
            case .animation:
                let animateion = AnimationIndexViewController()
                animateion.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(animateion, animated: true)
                break
            case .metal:
                let metal = MetalIndexViewController()
                metal.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(metal, animated: true)
            case .richtext:
                let rich = RichTextViewController()
                rich.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(rich, animated: true)
            case .promise:
                let promise = PromiseViewController()
                promise.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(promise, animated: true)
            case .permissions:
                let permission = PermissionsTableViewController()
                permission.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(permission, animated: true)
                break
            case .cellAlign:
                let align = AlignViewController()
                align.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(align, animated: true)
                break
            case .noData:
                self?.navigationController?.pushViewController(EmptyViewController(), animated: true)
            }
            }).disposed(by: disposeBag)
        
    }


}

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
    case segment
    case animation
    case metal
    case richtext
    case promise
    case permissions
    case cellAlign
    case noData
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
            return "URLNavigator应用"
        case .segment:
            return "JXSegmentView"
        case .animation:
            return "动画"
        case .metal:
            return "重金属"
        case .richtext:
            return "富文本"
        case .promise:
            return "异步编程库PromiseKit"
        case .permissions:
            return "权限管理"
        case .cellAlign:
            return "cellAlign"
        case .noData:
            return "Empty"
        }
    }
}
