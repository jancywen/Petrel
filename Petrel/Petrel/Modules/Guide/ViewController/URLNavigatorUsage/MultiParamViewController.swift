//
//  MultiParamViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/3/26.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit

class MultiParamViewController: UIViewController {

    
    
    /// 多个参数
    var name: String
    var score: String
    init(name:String, score: String) {
        self.name = name
        self.score = score
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        print("姓名:\(name) \n 分数:\(score)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
