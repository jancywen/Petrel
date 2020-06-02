//
//  PetrelPicCell.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/30.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit
import FSPagerView
import SnapKit

class PetrelPicCell: FSPagerViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentImageView)
        contentImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var contentImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        return view
    }()
}
