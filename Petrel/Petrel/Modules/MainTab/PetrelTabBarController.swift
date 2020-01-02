//
//  PetrelTabBarController.swift
//  Petrel
//
//  Created by wangwenjie on 2019/12/11.
//  Copyright © 2019 Petrel. All rights reserved.
//

import UIKit

class PetrelTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainvc = ViewController()
        mainvc.view.backgroundColor = .white
        let main = UINavigationController(rootViewController: mainvc)
        main.tabBarItem = UITabBarItem(title: "首页", image: nil, selectedImage: nil)
        
        let mine = UINavigationController(rootViewController: MineViewController())
        mine.tabBarItem = UITabBarItem(title: "我的", image: nil, selectedImage: nil)
        
        self.viewControllers = [main, mine]
        
    }
    

    

}
