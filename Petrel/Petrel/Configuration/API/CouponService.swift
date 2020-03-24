//
//  CouponService.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/21.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya
import Moya_SwiftyJSONMapper
import SwiftyJSON
import RxSwift
import RxCocoa

class CouponService {
    /// 可用优惠券
    func queryAvailableCoupon() -> Observable<[CouponModel]> {
        provider.rx.request(MultiTarget(CouponAPI.available))
            .map(to: [CouponModel.self])
            .asObservable()
            .catchError { (error) -> Observable<[CouponModel]> in
                print("error")
            print(error.localizedDescription)
            return Observable<[CouponModel]>.empty()
        }
    }
}
