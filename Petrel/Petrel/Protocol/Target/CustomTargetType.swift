//
//  CustomTargetType.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/29.
//  Copyright © 2019 Petrel. All rights reserved.
//

import Moya

protocol AuthorizedTargetType: TargetType {
    /// 返回是否需要授权
    var needsAuth: Bool {get}
}

extension AuthorizedTargetType {
    var needsAuth: Bool {
        return false
    }
}
