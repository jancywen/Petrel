//
//  MetalIndexViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/5/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class MetalIndexViewController: UIViewController {

    var tableView: UITableView!
    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Metal"
        
        tableView = UITableView(frame: self.view.frame, style: .plain)
        view.addSubview(tableView)
        
        let items = Observable.just([MetalIndexType.content])
        
        items.bind(to: tableView.rx.items){(tv, row, element) in
            let cell = tv.dequeueCell(UITableViewCell.self)!
            cell.textLabel?.text = element.titleStr
            cell.accessoryType = .disclosureIndicator
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MetalIndexType.self)
            .subscribe(onNext: modelSelected)
            .disposed(by: disposeBag)
    }
    
    func modelSelected(_ type: MetalIndexType) {
        switch type {
        case .content:
            let content = RenderContentViewController()
            navigationController?.pushViewController(content, animated: true)
        }
    }
}


enum MetalIndexType {
    case content
}

extension MetalIndexType {
    var titleStr: String {
        switch self {
        case .content:
            return "View's Content"
        }
    }
}
