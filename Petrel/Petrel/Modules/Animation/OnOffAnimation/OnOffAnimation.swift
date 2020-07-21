//
//  OnOffAnimation.swift
//  Petrel
//
//  Created by captain on 2020/7/21.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation


class OnOffAnimation:NSObject, UIViewControllerAnimatedTransitioning {
    
    var transitionType: TransitionAnimationType!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch transitionType {
        case .present:
            presentAnimation(using: transitionContext)
        case .dismiss:
            dismissAnimation(using: transitionContext)
        case .push:
            pushAnimation(using: transitionContext)
        case .pop:
            popAnimation(using: transitionContext)
        case .none:
            transitionContext.completeTransition(true)
        }
    }
    
    func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    func pushAnimation(using transitionContext: UIViewControllerContextTransitioning) {
       guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to),
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            transitionContext.completeTransition(true)
            return
        }
        let containerView = transitionContext.containerView
        
        // 左侧动画视图
        guard let leftFromView = fromView.snapshotView(afterScreenUpdates: false) else {
            containerView.addSubview(toView)
            transitionContext.completeTransition(true)
            return
        }
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: fromView.frame.size.width/2, height: fromView.frame.size.height))
        leftView.clipsToBounds = true
        leftView.addSubview(leftFromView)
        
        // 右侧动画视图
        guard let rightFromView = fromView.snapshotView(afterScreenUpdates: false) else {
            containerView.addSubview(toView)
            transitionContext.completeTransition(true)
            return
        }
        rightFromView.frame = CGRect(x: -fromView.frame.size.width/2, y: 0, width: fromView.frame.size.width, height: fromView.frame.size.height)
        let rightView = UIView(frame: CGRect(x: fromView.frame.size.width/2, y: 0, width: fromView.frame.size.width/2, height: fromView.frame.size.height))
        rightView.clipsToBounds = true
        rightView.addSubview(rightFromView)
        
        containerView.addSubview(toView)
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        
        fromView.isHidden = true
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .transitionFlipFromRight,
                       animations: {
                        
                        leftView.frame = CGRect(x: -fromView.frame.size.width/2, y: 0, width: fromView.frame.size.width/2, height: fromView.frame.size.height)
                        rightView.frame = CGRect(x: fromView.frame.size.width, y: 0, width: fromView.frame.size.width/2, height: fromView.frame.size.height)
                        
        }) { (finished) in
            fromView.isHidden = false
            leftView.removeFromSuperview()
            rightView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
    }
    func popAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to),
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            transitionContext.completeTransition(true)
            return
        }
        let containerView = transitionContext.containerView
        
        let leftView = UIView(frame: CGRect(x: -toView.frame.size.width/2, y: 0, width: toView.frame.size.width/2, height: toView.frame.size.height))
        leftView.clipsToBounds = true
        leftView.addSubview(toView)
        
        // 右侧动画视图
        guard let rightToView = toView.snapshotView(afterScreenUpdates: true) else {
            return
        }
        
        rightToView.frame = CGRect(x: -toView.frame.size.width/2, y: 0, width: toView.frame.size.width, height: toView.frame.size.height)
        let rightView = UIView(frame: CGRect(x: toView.frame.size.width, y: 0, width: toView.frame.size.width/2, height: toView.frame.size.height))
        rightView.clipsToBounds = true
        rightView.addSubview(rightToView)
        
        toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.size.height)

        containerView.addSubview(fromView)
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .transitionFlipFromRight,
                       animations: {
                        leftView.frame = CGRect(x: 0, y: 0, width: toView.frame.size.width/2, height: toView.frame.size.height)
                        rightView.frame = CGRect(x: toView.frame.size.width/2, y: 0, width: toView.frame.size.width/2, height: toView.frame.size.height)
        }) { (finished) in
            leftView.removeFromSuperview()
            rightView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            toView.isHidden = false
            containerView.addSubview(toView)
        }
        
    }
}
