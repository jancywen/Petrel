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
        
        let items = Observable<[MetalIndexType]>.just([.content, .triangle_oc, .triangle_swift, .image])
        
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
        case .triangle_oc:
            let triangle = RenderTriangleViewController()
            triangle.oc = true
            navigationController?.pushViewController(triangle, animated: true)
        case .triangle_swift:
            let triangle = RenderTriangleViewController()
            triangle.oc = false
            navigationController?.pushViewController(triangle, animated: true)
        case .image:
            let image = RenderImageViewController()
            navigationController?.pushViewController(image, animated: true)
        }
    }
}


enum MetalIndexType {
    case content
    case triangle_oc
    case triangle_swift
    case image
}

extension MetalIndexType {
    var titleStr: String {
        switch self {
        case .content:
            return "View's Content"
        case .triangle_oc, .triangle_swift:
            return "2D Triangle"
        case .image:
            return "图片纹理"
        }
    }
}
