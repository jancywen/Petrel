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
import MJRefresh

class RefreshViewModel {
    /// 列表数据
    let tableData = BehaviorRelay<[String]>(value: [])
    /// 停止下拉刷新
    let endHeaderRefreshing: Driver<Bool>
    /// 停止上提加载
    let endFooterRefreshingWithState: Driver<MJRefreshState>
    
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

        self.endFooterRefreshingWithState = Driver.combineLatest(self.tableData.asDriver(), footerRefreshData.asDriver()) { (list1, list2) in
            if list1.count == 45 {
                return .noMoreData
            }else {
                return .idle
            }
        }.debug()
        
        headerRefreshData.drive(onNext: { (items) in
            self.tableData.accept(items)
        }).disposed(by: dependency.disposeBag)
        
        footerRefreshData.drive(onNext: { (items) in
            self.tableData.accept(self.tableData.value + items)
        }).disposed(by: dependency.disposeBag)
        
    }
    
}
