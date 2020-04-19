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
}

extension AnimationSectionModel: SectionModelType {
    
    typealias Item = AnimationType
    
    var items: [AnimationType] {
        switch self {
        case .cell(title: _, itmes: let items):
            return items.map{$0}
        }
    }
    
    init(original: AnimationSectionModel, items: [AnimationType]) {
        switch original {
        case .cell(title: let title, itmes: _):
            self = .cell(title: title, itmes: items)
        }
    }
}

extension AnimationSectionModel {
    var title: String {
        switch self {
        case .cell(title: let title, itmes: _):
            return title
        }
    }
}
