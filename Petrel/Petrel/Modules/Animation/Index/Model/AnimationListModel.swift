//
//  AnimationListModel.swift
//  Petrel
//
//  Created by wangwenjie on 2020/4/19.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

enum AnimationSectionModel {
    case cell(title: String, itmes:[AnimationType])
    case table(title: String, items: [AnimationType])
    case view(title: String, items:[AnimationType])
}

extension AnimationSectionModel: SectionModelType {
    
    typealias Item = AnimationType
    
    var items: [AnimationType] {
        switch self {
        case .cell(title: _, itmes: let items):
            return items.map{$0}
        case .table(title: _, items: let items):
            return items.map{$0}
        case .view(title: _, items: let items):
            return items.map{$0}
        }
    }
    
    init(original: AnimationSectionModel, items: [AnimationType]) {
        switch original {
        case .cell(title: let title, itmes: _):
            self = .cell(title: title, itmes: items)
        case .table(title: let title, items: _):
            self = .table(title: title, items: items)
        case .view(title: let title, items: _):
            self = .view(title: title, items: items)
        }
    }
}

extension AnimationSectionModel {
    var title: String {
        switch self {
        case .cell(title: let title, itmes: _):
            return title
        case .table(title: let title, items: _):
            return title
        case .view(title: let title, items: _):
            return title
        }
    }
}
