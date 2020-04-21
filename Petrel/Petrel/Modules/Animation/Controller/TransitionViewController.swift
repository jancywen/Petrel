//
//  TransitionViewController.swift
//  Petrel
//
//  Created by wangwenjie on 2020/4/20.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        

        let redView:UIView = UIView(frame: CGRect(x:20, y:20, width:280, height:400))
        redView.backgroundColor = UIColor.red
        self.view.insertSubview(redView, at: 0)
         
        let blueView:UIView = UIView(frame: CGRect(x:20, y:20, width: 280, height:400))
        blueView.backgroundColor = UIColor.blue
        self.view.insertSubview(blueView, at: 1)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push //推送类型
        transition.subtype = CATransitionSubtype.fromLeft //从左侧
        self.view.exchangeSubview(at: 1, withSubviewAt: 0)
        self.view.layer.add(transition, forKey: nil)
    }

}
