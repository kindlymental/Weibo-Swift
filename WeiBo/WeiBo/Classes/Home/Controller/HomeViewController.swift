//
//  HomeViewController.swift
//  WeiBo
//
//  Created by mac on 16/7/26.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private func userIsLogin() {
        // 该页面游客身份有登录和注册按钮
        hasBarButtonItem = false

    }
    
    override func loadView() {
        userIsLogin()
        
        super.loadView()
        
        isLogin = true
    }
    
    // MARK:- 懒加载属性
    private lazy var titleView : TitleView = TitleView()
    
    // 因为home控制器引用animator，animator引用闭包，闭包又调用self（Home）控制器，所以会产生循环引用
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { [weak self] (isPresented) in
        // 在闭包中如果使用当前对象的属性或调用方法，必须加self    如果在一个函数中如果出现歧义属性需要加self，闭包中使用当前对象属性或方法需要加self
        self?.titleView.selected = isPresented
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            // 给rotationView添加动画效果
            visitorView.addImageViewRotationAnimation()
            
            return
        }
        
        // MARK:- 登陆之后功能
        loadNavigationBar()
    }
}

extension HomeViewController {
    // 导航条
    private func loadNavigationBar() {
        
        let leftBarButton : UIButton = UIButton(image: "navigationbar_friendattention",selectedImage: "navigationbar_friendattention_highlighted",itemDirection: .ItemLeft)
        leftBarButton.addTarget(self, action: #selector(HomeViewController.leftBarButtonClick), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        let rightBarButton : UIButton = UIButton(image: "navigationbar_pop",selectedImage: "navigationbar_pop_highlighted",itemDirection: .ItemRight)
        rightBarButton.addTarget(self, action: #selector(HomeViewController.rightBarButtonClick), forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        // titleView
        titleView.setTitle("lrjdaml", forState: .Normal)
        titleView.addTarget(self, action: #selector(HomeViewController.titleViewClick), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleView
    }
    
    @objc private func leftBarButtonClick() {
        
    }
    
    @objc private func rightBarButtonClick() {
        
    }
    
    @objc private func titleViewClick() {
        // 通过监听动画是弹出和消失来确定箭头朝上还是朝下
        
        
        // 自定义转场
        let popoverVc = PopoverViewController()
        
        // 设置modal控制器属性，使得modal出来控制器后，后面的控制器不会消失
        popoverVc.modalPresentationStyle = .Custom
        
        // 自定义转场
        let containerWidth : CGFloat = 160
        
        popoverAnimator.presentedFrame = CGRect(x: (screenW - containerWidth)*0.5, y: 64-10, width: containerWidth, height: 200)
        popoverVc.transitioningDelegate = popoverAnimator
        
        presentViewController(popoverVc, animated: true, completion: nil)
    }
}

