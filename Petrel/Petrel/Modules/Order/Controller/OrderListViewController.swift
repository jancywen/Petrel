//
//  OrderListViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/4/15.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import JXSegmentedView

import MJRefresh

class OrderListViewController: UIViewController {

    
    var tableView: UITableView!
    
    var operateType: OrderOperateType = .single
    
    var statusType: OrderStatusType
    
    init(type: OrderStatusType ) {
        self.statusType = type

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.queryList(true)
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self] in
            self?.queryList(false)
        })
        
    }
    
   
    // MARK: action
    func operateAction(_ type: OrderOperateType) {
        operateType = type
//        updateUI()
        tableView.reloadData()
    }
    
    // MARK: network
    func queryList(_ refresh: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
            self?.updateUI()
        }
    }
    
    // MARK: private
    private func updateUI() {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshingWithNoMoreData()
        tableView.reloadData()
    }
}
//MARK: TABLEVIEWDELEGATE DATASOURCE
extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
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
    }

}


extension OrderListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
