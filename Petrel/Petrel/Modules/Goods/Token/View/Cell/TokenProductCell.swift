//
//  TokenProductCell.swift
//  Petrel
//
//  Created by captain on 2020/7/17.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit

class TokenProductCell: UITableViewCell {

    
    
    var product: TokenProduct? {
        didSet {
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}