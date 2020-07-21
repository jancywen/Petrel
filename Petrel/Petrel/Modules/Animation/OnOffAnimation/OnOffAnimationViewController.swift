//
//  OnOffAnimationViewController.swift
//  Petrel
//
//  Created by captain on 2020/7/21.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit

class OnOffAnimationViewController: UIViewController, UINavigationControllerDelegate {

    
    let transitionAnimation = OnOffAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationController.Operation.push {
            self.transitionAnimation.transitionType = .push
        }else if (operation == .pop) {
            self.transitionAnimation.transitionType = .pop
        }
        return self.transitionAnimation
    }

}
