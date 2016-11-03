//
//  BaseViewController.swift
//  WeiBo
//
//  Created by mac on 16/7/28.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    // 访客视图标识
    var isLogin : Bool = UserAccountTool.shareInstance.isLogin
    
    // 访客视图
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    // login and register BarButtonItem
    var hasBarButtonItem : Bool = false

    
    // MARK:- 系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : loadVisitorView()
        
        // visitor have login and register item on the navigationBar
        if isLogin == false && hasBarButtonItem == true {
            loadBarButtonItem()
        } 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}

// MARK:- 设置UI界面
extension BaseViewController {
    // load visitor view
    private func loadVisitorView() -> Void {
        view = visitorView
        
        // 获取visitorView中的登录和注册按钮
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginClick), forControlEvents: .TouchUpInside)
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerClick), forControlEvents: .TouchUpInside)
    }
    
    // setup navigationBarButtonItem
    private func loadBarButtonItem() {
        
        // 自定义tabBarItem
        let registerBtn : UIButton = UIButton(title: "注册", itemDirection: .ItemLeft)
        registerBtn.addTarget(self, action: #selector(BaseViewController.registerClick), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: registerBtn)
        
        let loginBtn : UIButton = UIButton(title: "登录", itemDirection: .ItemRight)
        loginBtn.addTarget(self, action: #selector(BaseViewController.loginClick), forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loginBtn)
    }
}

// MARK:- 登录、注册方法
extension BaseViewController {
    // 注册
    @objc private func registerClick() {
        Log("注册成功")
    }
    
    // 登录
    @objc private func loginClick() {
        let oauthVc = OAuthViewController()
        
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        
        presentViewController(oauthNav, animated: true, completion: nil)
    }
}