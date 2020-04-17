//
//  OrderListViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/4/15.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import JXSegmentedView

import RxSwift
import RxCocoa


class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var tableView: UITableView!
    
    var operateType: OrderOperateType = .single
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        let item = UIBarButtonItem(title: "批量操作", style: .plain, target: self, action: #selector(batchAction))
        navigationItem.rightBarButtonItem = item
        
    }
    
    
    @objc func batchAction() {
        if operateType == .single {
            operateType = .batch
        }else {
            operateType = .single
        }
        tableView.reloadData()
    }
//MARK: TABLEVIEWDELEGATE DATASOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(OrderListCell.self) as! OrderListCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let orderCell = cell as! OrderListCell

        switch operateType {
                case .batch:
                    
                    
                    UIView.animate(withDuration: 3) {
                        orderCell.leftInterval.constant = 100
                    }
                    
        //            UIView.beginAnimations(nil, context: nil)
        //            UIView.setAnimationDuration(2.0)
        //            orderCell.leftInterval.constant = 100
        //            UIView.setAnimationCurve(.easeOut) //设置动画相对速度
        //            UIView.commitAnimations()
                case .single:
                    UIView.beginAnimations(nil, context: nil)
                    UIView.setAnimationDuration(2.0)
                    orderCell.leftInterval.constant = 0
                    UIView.setAnimationCurve(.easeOut) //设置动画相对速度
                    UIView.commitAnimations()
                }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let orderCell = cell as! OrderListCell
//
//        switch operateType {
//        case .batch:
//
//
//            UIView.animate(withDuration: 3) {
//                orderCell.leftInterval.constant = 100
//            }
//
////            UIView.beginAnimations(nil, context: nil)
////            UIView.setAnimationDuration(2.0)
////            orderCell.leftInterval.constant = 100
////            UIView.setAnimationCurve(.easeOut) //设置动画相对速度
////            UIView.commitAnimations()
//        case .single:
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationDuration(2.0)
//            orderCell.leftInterval.constant = 0
//            UIView.setAnimationCurve(.easeOut) //设置动画相对速度
//            UIView.commitAnimations()
//        }
    }

}


extension OrderListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
