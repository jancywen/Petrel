//
//  SettlementGoodsCell.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit

class SettlementGoodsCell: UITableViewCell {

    @IBOutlet weak var goodsCover: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var goodsSku: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var goodsCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ goods: GoodsModel) {
        
    }
}
