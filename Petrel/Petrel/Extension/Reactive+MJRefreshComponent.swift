//
//  Reative+MJRefreshComponent.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/29.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base: MJRefreshComponent {
    
    
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    var endRefreshing: Binder<Bool> {
        return Binder(base){refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}
