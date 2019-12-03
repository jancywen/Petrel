//
//  NetworkService.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/29.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkService {
    func getRandomResult() -> Driver<[String]> {
        
        let items = (0..<15).map {_ in
            "随机数据\(Int(arc4random()))"
        }
        let observable = Observable.just(items)
        return observable.delay(1, scheduler: MainScheduler.instance).asDriver(onErrorDriveWith: Driver.empty())
    }
    
    func getNewRandomResult(_ page: Int) -> Driver<[String]> {
        print("***\(page)")
        
        if page == 0 {
            return Driver.empty()
        }
        
        let items = (0..<15).map {_ in
            "随机数据\(Int(arc4random()))"
        }
        let observable = Observable.just(items)
        return observable.delay(1, scheduler: MainScheduler.instance).asDriver(onErrorDriveWith: Driver.empty())
    }
}
