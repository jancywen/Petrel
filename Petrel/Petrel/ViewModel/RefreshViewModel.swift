//
//  File.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/29.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RefreshViewModel {
    /// 列表数据
    let tableData = BehaviorRelay<[String]>(value: [])
    /// 停止下拉刷新
    let endHeaderRefreshing: Driver<Bool>
    /// 停止上提加载
    let endFooterRefreshing: Driver<Bool>
    /// 显示底线
    let endRefreshingWithNoMoreData: Driver<Bool>
    
    var total = 0
    
    init(input:
        (headerRefresh: Driver<Void>,
        footerRefresh: Driver<Void>),
         dependency:
        (disposeBag: DisposeBag,
        networkService: NetworkService)) {
        
        let headerRefreshData = input.headerRefresh.startWith(())
            .flatMap {_ in dependency.networkService.getRandomResult() }
                
        let footerRefreshData = input.footerRefresh.withLatestFrom(tableData.asDriver()).flatMap { (list)  in
            return dependency.networkService.getNewRandomResult(list.count/15)
        }

        self.endHeaderRefreshing = headerRefreshData.map{_ in true}
        self.endFooterRefreshing = footerRefreshData.map{_ in true}
        self.endRefreshingWithNoMoreData = self.tableData.asDriver().map{$0.count == 30}
        
        
        headerRefreshData.drive(onNext: { (items) in
            self.tableData.accept(items)
        }).disposed(by: dependency.disposeBag)
        
        footerRefreshData.drive(onNext: { (items) in
            self.tableData.accept(self.tableData.value + items)
        }).disposed(by: dependency.disposeBag)
        
    }
    
}
