//
//  AlignCollectionReusableView.swift
//  Petrel
//
//  Created by captain on 2020/8/12.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation
class AlignCollectionReusableView: UICollectionReusableView {
    var label : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: self.bounds)
        label.textAlignment = NSTextAlignment.center
        label.text = "我是区头"
        label.font = UIFont.systemFont(ofSize: 25)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
