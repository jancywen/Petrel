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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
        
    }
    
    
    private func configUI() {
        
        rightBtn = UIButton(title: "批量", textColor: .black, font: UIFont.systemFont(ofSize: 14))
        rightBtn.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        navigationItem.rightBarButtonItem = rightItem
        
        segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.titles = [OrderStatusType.obligation.statusStr,
                                      OrderStatusType.undeliver.statusStr,
                                      OrderStatusType.unreceive.statusStr,
                                      OrderStatusType.complete.statusStr,
                                      OrderStatusType.close.statusStr]
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = self.segmentedDataSource
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        segmentedView.indicators = [indicator]
        
        listContainerView = JXSegmentedListContainerView(dataSource: self)
        view.addSubview(self.listContainerView)
        segmentedView.listContainer = listContainerView
        
        
    }

    
    @objc func rightAction(_ sender: UIButton) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: DeviceTool.navBarHeight(), width: view.bounds.size.width , height: 50)
        listContainerView.frame = CGRect(x: 0, y:DeviceTool.navBarHeight() + 50, width: view.bounds.size.width, height: view.bounds.size.height - 50 - DeviceTool.navBarHeight())
    }
    
}

extension OrderMainViewController: JXSegmentedViewDelegate {
    
}
extension OrderMainViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.titles.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return OrderListViewController()
    }
    
    
}
