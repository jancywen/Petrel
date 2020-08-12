//
//  AlignCollectionViewCell.swift
//  Petrel
//
//  Created by captain on 2020/8/12.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation

class AlignCollectionViewCell: UICollectionViewCell {
    var content : String = "0"{
        willSet{
            label.frame = self.bounds
            label.text = newValue
        }
    }
    var label : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.init(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 0.8
        label = UILabel(frame: self.bounds)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.init(red: 99/255.0, green: 99/255.0, blue: 99/255.0, alpha: 1.0)
        self.contentView.addSubview(label)
    }
    func setContent(content : String){
        label.frame = self.bounds
        label.text = content
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
