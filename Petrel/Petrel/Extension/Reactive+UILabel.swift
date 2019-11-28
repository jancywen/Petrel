//
//  Reactive+UILabel.swift
//  Petrel
//
//  Created by wangwenjie on 2019/11/27.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension Reactive where Base: UILabel {
    
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}
