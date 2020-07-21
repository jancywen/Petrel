//
//  SideslipViewController.swift
//  Petrel
//
//  Created by geeky on 2020/6/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SideslipViewController: UIViewController {
    
    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "cell侧滑删除"
        
        tableView = UITableView(frame: self.view.frame, style: .plain)
        view.addSubview(tableView)
        
        
        Observable.just([
            "西游记","三国演义","水浒传","红楼梦 红楼梦 红楼梦 红楼梦 红楼梦 红楼梦 "
        ]).bind(to: tableView.rx.items) {(tableView, row, element) in
            let cell = tableView.dequeueCell(SideslipTableViewCell.self) as! SideslipTableViewCell
            
            cell.delegate = self
            cell.editButtonArray = [UIButton(title:"置顶", backgroundColor:kYFCellEditButtonMore),
                                    UIButton(title:"已读", backgroundColor:kYFCellEditButtonIsRead),
                                    UIButton(title:"删除")]
            cell.confirmButton = UIButton(title:"确认删除", backgroundColor:kYFCellEditButtonDelele)
            cell.confirmButtonIndex = 2
            
            cell.label.text = element
            return cell
        }.disposed(by: disposeBag)
        
    }
    
    
}

extension SideslipViewController: SideslipCellDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didClickedEditButtonAt buttonIndex: Int, At indexPath: IndexPath) {
        print("clicked button index: \(buttonIndex) at row: \(indexPath.row)")
    }
    
    
}
