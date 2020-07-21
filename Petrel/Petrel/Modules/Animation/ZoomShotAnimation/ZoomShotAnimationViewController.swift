//
//  ZoomShotAnimationViewController.swift
//  Petrel
//
//  Created by captain on 2020/7/20.
//  Copyright © 2020 Petrel. All rights reserved.
//

import UIKit

class ZoomShotAnimationViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let transitionAnimation = ZoomShotAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
