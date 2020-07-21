//
//  SideslipTableViewCell.swift
//  Petrel
//
//  Created by geeky on 2020/6/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit

class SideslipTableViewCell: SideslipCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
