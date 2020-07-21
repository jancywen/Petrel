//
//  TransitionAnimationIndexViewController.swift
//  Petrel
//
//  Created by captain on 2020/7/21.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit

class TransitionAnimationIndexViewController: UIViewController {

    @IBOutlet weak var productImv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "转场动画"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

    @IBAction func normalAction(_ sender: Any) {
        navigationController?.pushViewController(SystemAnimationViewController(), animated: true)

    }
    @IBAction func zoomShotAction(_ sender: Any) {
        let vc = ZoomShotAnimationViewController()
        navigationController?.delegate = vc
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onoffAction(_ sender: Any) {
        
        let vc = OnOffAnimationViewController()
        navigationController?.delegate = vc
        navigationController?.pushViewController(vc, animated: true)
    }
}



enum TransitionAnimationType {
    case present
    case dismiss
    case push
    case pop
}

