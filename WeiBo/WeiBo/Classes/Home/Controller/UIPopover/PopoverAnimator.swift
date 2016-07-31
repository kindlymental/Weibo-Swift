//
//  PopoverAnimator.swift
//  WeiBo
//
//  Created by mac on 16/7/30.
//  Copyright © 2016年 lyl. All rights reserved.
//

// 从HomeViewController.swift文件中抽取出来的关于titleView的转场以及自定义动画的弹出和消失效果
// PopoverViewController的 transitioningDelegate 代理

import UIKit

class PopoverAnimator: NSObject {
    // 设置一个标识 标识是执行弹出动画还是消失动画
    var isPresented : Bool = false
    // popoverView frame
    var presentedFrame : CGRect = CGRectZero
    
    // 动画是弹出还是消失闭包
    var callBack : ((isPresented : Bool) -> ())?
    
    init(callBack : (isPresented : Bool) -> ()) {
        self.callBack = callBack
    }
}

// MARK:- PopoverControllerDelegate 自定义转场
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    
    // 应用自定义UIPresentationController  改变尺寸
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentation =  PresentationController.init(presentedViewController: presented, presentingViewController: presenting)
        presentation.presentedFrame = presentedFrame
        return presentation
    }
    
    // 自定义弹出动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        
        // 执行弹出动画闭包  如果想要调用闭包，闭包必须是有值的，不能是可选类型 需要强制解包
        callBack!(isPresented : isPresented)
        
        return self
    }
    
    // 自定义消失动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        
        // 执行消失动画闭包
        callBack!(isPresented : isPresented)
        
        return self
    }
    
}

// MARK:- 弹出和消失动画代理  UIViewControllerAnimatedTransitioning
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    // 动画执行时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // 获取转场上下文  获取弹出和消失的view
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    // 自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // 获取弹出的view  UITransitionContextFromViewKey 消失view UITransitionContextToViewKey 弹出view
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        // 将弹出的view添加到containerView中
        transitionContext.containerView()?.addSubview(presentedView)
        // 执行动画
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            presentedView.transform = CGAffineTransformIdentity
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    // 自定义消失动画
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        let dismissedView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            dismissedView?.transform = CGAffineTransformMakeScale(1.0, 0.0001)
        }) { (_) in
            dismissedView?.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
    
}
