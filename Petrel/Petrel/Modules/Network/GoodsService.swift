//
//  GoodsService.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya
import RxSwift

final class GoodsService {
    
    func goodsDetailInfo(_ goodsId: String) -> Observable<Goods> {
        
        return Observable.just(Goods(jsonData: "{}")!)
        
//        provider.rx.request(MultiTarget(GoodsAPI.detail))
//            .map(to: Goods.self)
//            .asObservable()
//            .catchError { (error) -> Observable<Goods>  in
//            print(error.localizedDescription)
//            return Observable.empty()
//        }
//
    }
}
