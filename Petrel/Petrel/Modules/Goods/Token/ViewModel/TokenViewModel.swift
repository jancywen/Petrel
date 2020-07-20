//
//  TokenViewModel.swift
//  Petrel
//
//  Created by captain on 2020/7/16.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class TokenViewModel {
    
    let dataSource = BehaviorRelay<[TokenSectionModel]>(value: [])
    
    init(_ service: GoodsService, _ disposeBag: DisposeBag) {
        
        
        service.queryTokenList().map({self.operateData($0)})
            .asDriver(onErrorJustReturn: [])
            .drive(dataSource)
            .disposed(by: disposeBag)
        
    }
    
    func operateData(_ token: Token) -> [TokenSectionModel]  {
        let products = token.products.map({TokenSectionItem.product(product: $0)})
        let markets = token.markets.map({TokenSectionItem.market(market: $0)})
        
        return [.product(title: "Token Product", items: products),
                .market(title: "Token Market Price", items: markets)]
    }
    
}


enum TokenSectionModel {
    case product(title: String, items: [TokenSectionItem])
    case market(title: String, items: [TokenSectionItem])
}
extension TokenSectionModel:SectionModelType {
    
    typealias Item = TokenSectionItem
    
    var items: [TokenSectionItem] {
        switch self {
        case .product(title: _, items: let items):
            return items
        case .market(title: _, items: let items):
            return items
        }
    }
    
    init(original: Self, items: [TokenSectionItem]) {
        switch original {
        case .product(title: let title, items: let items):
            self = .product(title: title, items: items)
        case .market(title: let title, items: let items):
            self = .market(title: title, items: items)
        }
    }
}

enum TokenSectionItem {
    case product(product: TokenProduct)
    case market(market: TokenMarket)
}
