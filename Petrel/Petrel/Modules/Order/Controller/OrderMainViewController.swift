//
//  OrderMainViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/4/15.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit
import JXSegmentedView
import RxCocoa
import RxSwift

class OrderMainViewController: UIViewController {
    
    
    var segmentedView : JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    
    var rightBtn: UIButton!
    
    var operateType:OrderOperateType! = .single
    
    var orderListVCs = [OrderListViewController]()
    var orderListTypes:[OrderStatusType] = [.obligation, .undeliver, .unreceive, .complete, .close]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
        
    }
    
    
    private func configUI() {
        
        rightBtn = UIButton(title: operateType.title, textColor: .black, font: UIFont.systemFont(ofSize: 14))
        rightBtn.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        navigationItem.rightBarButtonItem = rightItem
        
        /// 初始化控制器
        orderListVCs = orderListTypes.map{OrderListViewController(type: $0)}
        
        segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.titles = orderListTypes.map{$0.statusStr}
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = self.segmentedDataSource
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        segmentedView.indicators = [indicator]
        
        listContainerView = JXSegmentedListContainerView(dataSource: self)
        view.addSubview(self.listContainerView)
        segmentedView.listContainer = listContainerView
        
        segmentedView.frame = CGRect(x: 0, y: DeviceTool.navBarHeight(), width: view.bounds.size.width , height: 50)
        listContainerView.frame = CGRect(x: 0, y:DeviceTool.navBarHeight() + 50, width: view.bounds.size.width, height: view.bounds.size.height - 50 - DeviceTool.navBarHeight())

    }
    
    
    @objc func rightAction(_ sender: UIButton) {
        operateType = operateType == .single ? .batch : .single
        rightBtn.setTitle(operateType.title, for: .normal)
        
        segmentedView.isUserInteractionEnabled = operateType == .single
        listContainerView.frame = CGRect(x: 0, y:DeviceTool.navBarHeight() + 50, width: view.bounds.size.width, height: view.bounds.size.height - 50 - DeviceTool.navBarHeight() - (operateType == .single ? 0 : 90))
        segmentedView.contentScrollView?.isScrollEnabled = operateType == .single
        if segmentedView.selectedIndex < orderListVCs.count {
            let vc = orderListVCs[segmentedView.selectedIndex]
            vc.operateAction(operateType)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
}

extension OrderMainViewController: JXSegmentedViewDelegate {
    
}
extension OrderMainViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.titles.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        guard index < orderListVCs.count else {
            return OrderListViewController(type: .close)
        }
        return orderListVCs[index]
    }
    
    
}
