//
//  OSSManager.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/13.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OSSManager {
    
    let imageUrls: Driver<Array<String>>
    
    init(images: Array<UIImage>, dependency:(networkService: OSSNetworkService, disposeBag: DisposeBag)) {
        
        func upload(oss: OSSAccessModel) -> Driver<Array<String>> {
            return Driver.just([""])
        }

        imageUrls = dependency.networkService.ossAccess().flatMap{OSSManager.upload(oss: $0, images: images)}.asDriver(onErrorJustReturn: [])
    }
    
    
    static func upload(oss: OSSAccessModel, images: Array<UIImage>) -> Driver<Array<String>> {
        guard images.count > 0 else {
            return Driver.just([""])
        }

        let mutArr = ["a", "b", "c", "d", "e", "f", "g"]
(mutArr as NSArray).enumerateObjects(options: .reverse, using: { obj, idx, stop in

})
        
        return Driver.just([""])

    }
}
