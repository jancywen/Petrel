//
//  GoodsService.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/25.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya
import RxSwift
import SwiftyJSON

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
    func someRequest() {
        provider.request(MultiTarget(GoodsAPI.detail)) { result in
            switch result {
            case .success(let response):
                try? response.filterSuccessfulStatusCodes()
                break
            case .failure(let error):
                break
            }
            let response = try? result.value?.filterSuccessfulStatusCodes()
        }
    }
    
    func queryTokenList() -> Observable<Token> {
        provider.rx.request(MultiTarget(GoodsAPI.token))
            .filterSuccessfulStatusCodes()
            .map(to: Token.self)
            .asObservable()
            .catchError { (error) -> Observable<Token> in
                if let path = Bundle.main.path(forResource: "Token", ofType: "json"),
                    let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                    let json = try? JSON(data: data, options: .mutableContainers),
                    let token = Token(jsonData: json) {
                    return Observable.just(token)
                }
                
//                let path = Bundle.main.path(forResource: "Token", ofType: "json")!
//                let url = URL(fileURLWithPath: path)
//                do {
//                    let data = try Data(contentsOf: url)
//                    let json = try JSON(data: data, options: .mutableContainers)
//                    let token = Token(jsonData: json)
//                    return Observable.just(token!)
//                }catch {
//                    print(error)
//                }
                
                return Observable.empty()
        }
    }
    
    
    func querySome() {
//        provider.rx.converenceRequest(MultiTarget(GoodsAPI.token)).map(<#T##type: Decodable.Protocol##Decodable.Protocol#>, atKeyPath: <#T##String?#>, using: <#T##JSONDecoder#>, failsOnEmptyData: <#T##Bool#>)
    }
    
    
    
}

