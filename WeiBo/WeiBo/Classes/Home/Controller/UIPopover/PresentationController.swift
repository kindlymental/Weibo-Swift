//
//  PresentationController.swift
//  WeiBo
//
//  Created by mac on 16/7/30.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    // MARK:- 懒加载属性
    private lazy var coverView : UIView = UIView()
    
    lazy var presentedFrame : CGRect = CGRectZero
    
    // 设置装载modal出来的控制器的容器的尺寸
    override func containerViewWillLayoutSubviews() {
        let containerWidth : CGFloat = 160
   
        presentedView()?.frame = CGRect(x: (screenW - containerWidth)*0.5, y: 64-10, width: containerWidth, height: 200)
        presentedView()?.frame = presentedFrame
        // 一般不提倡修改系统自身的对象属性  在containerView上加上蒙板后也就会产生相同效果
//        presentedView()?.backgroundColor = UIColor.clearColor()
        
        // 添加蒙板
        loadCoverView()
    }
}

extension PresentationController {
    // 设置蒙板
    private func loadCoverView() {
        // 蒙板 不能添加到最上面，会遮挡住tableView
        containerView?.insertSubview(coverView, atIndex: 0)
        
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        // containerView 是整个页面的尺寸
        coverView.frame = containerView?.bounds ?? CGRectZero
        
        // 添加手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureClick))
        coverView.addGestureRecognizer(tapGesture)
    }
    
    // 手势点击事件监听
    @objc func tapGestureClick() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}