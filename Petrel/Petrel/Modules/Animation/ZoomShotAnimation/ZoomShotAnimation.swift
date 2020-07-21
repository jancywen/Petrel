//
//  ZoomShotAnimation.swift
//  Petrel
//
//  Created by captain on 2020/7/20.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation

class ZoomShotAnimation:NSObject, UIViewControllerAnimatedTransitioning {

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
        transitionContext.completeTransition(true)
    }
    func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(true)
    }
    func pushAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? ZoomShotAnimationViewController else {
            return
        }
        
        var fromVC: TransitionAnimationIndexViewController!
        
        if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.isKind(of: UIViewController.self) ?? false,
            let nav = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UINavigationController,
            let indexVC = nav.viewControllers.last as? TransitionAnimationIndexViewController {
            fromVC = indexVC
        }else if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.isKind(of: TransitionAnimationIndexViewController.self) ?? false,
            let indexVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? TransitionAnimationIndexViewController {
            fromVC = indexVC
        }
        
//        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
//        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
        let containerView = transitionContext.containerView
        
        guard let imv = fromVC.productImv, let window = UIApplication.shared.keyWindow else {
            return
        }
        //snapshotViewAfterScreenUpdates 对imv截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
        let tempView = imv.snapshotView(afterScreenUpdates: false)
        tempView?.frame = imv.convert(imv.bounds, to: window)
        
        
//        toView?.alpha = 0
        
        toVC.view.alpha = 0

        containerView.addSubview(toVC.view)
        containerView.addSubview(tempView!)

        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            tempView?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 280)
            
        }) { (finished) in
            toVC.view.alpha = 1
            tempView?.removeFromSuperview()
//            transitionContext.completeTransition(true)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
    func popAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? ZoomShotAnimationViewController else {
            return
        }
        
        var toVC: TransitionAnimationIndexViewController!
        
        if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.isKind(of: UIViewController.self) ?? false,
            let nav = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController,
            let indexVC = nav.viewControllers.last as? TransitionAnimationIndexViewController {
            toVC = indexVC
        }else if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.isKind(of: TransitionAnimationIndexViewController.self) ?? false,
            let indexVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? TransitionAnimationIndexViewController {
            toVC = indexVC
        }
        
        
        let containerView = transitionContext.containerView

        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push //推送类型
        transition.subtype = CATransitionSubtype.fromLeft //从左侧
        containerView.exchangeSubview(at: 1, withSubviewAt: 0)
        containerView.layer.add(transition, forKey: nil)
        
        transitionContext.completeTransition(true)
    }
    
}
