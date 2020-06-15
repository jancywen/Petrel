//
//  RichTextViewController.swift
//  Petrel
//
//  Created by geeky on 2020/6/12.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit

class RichTextViewController: UIViewController , UITextViewDelegate{

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var alertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributedStr = NSMutableAttributedString(string:"欢迎使用药道云APP！\n我们将通过《用户服务协议及隐私声明》帮助你了解我们如何收集、使用、存储和共享个人信息，以及你享有的相关权利。您需充分阅读并理解本政策的内容，若你同意，请点击下方按钮开始接受我们的服务。" )
        
        attributedStr.addAttribute(NSAttributedString.Key.link, value: "CustomTapEvents://", range: attributedStr.mutableString.range(of: "《用户服务协议及隐私声明》"))
//        attributedStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, attributedStr.length))
        textView.attributedText = attributedStr
//
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alertView.isHidden = UserDefaults.standard.bool(forKey: "alertHidden")
        
    }
    
    @IBAction func quite(_ sender: Any) {
        abort()
    }
    
    @IBAction func ensure(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "alertHidden")
        alertView.isHidden = true
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "CustomTapEvents" {
            print("跳转到。。。。。")
            let vc = UIViewController()
            vc.title = "用户服务协议及隐私声明"
            navigationController?.pushViewController(vc, animated: true)
            return false
        }
        return true
    }
}
