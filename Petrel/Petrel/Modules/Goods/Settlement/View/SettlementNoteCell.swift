//
//  SettlementNoteCell.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/20.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit

class SettlementNoteCell: UITableViewCell, UITextViewDelegate {

    
    @IBOutlet weak var textView: PKTextView!
    @IBOutlet weak var subLabel: UILabel!
    
    var endEdit: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
        textView.placeholder = "请输入，最多140字"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ title: String, content: String) {
        textView.text = content
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let count = textView.text.count + text.count
        subLabel.text = "\(count)/140"
        return count < 140
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        endEdit?(textView.text)
    }
}
