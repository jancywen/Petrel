//
//  SettlementAddressCell.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit

class SettlementAddressCell: UITableViewCell {

    @IBOutlet weak var emptyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(_ address: AddressModel?) {
        emptyLabel.isHidden = address != nil
    }
    
}
