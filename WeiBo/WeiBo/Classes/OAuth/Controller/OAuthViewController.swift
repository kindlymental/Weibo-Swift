//
//  OAuthViewController.swift
//  WeiBo
//
//  Created by mac on 16/7/31.
//  Copyright © 2016年 lyl. All rights reserved.
//

/// 微博授权：申请微博开发者账号，并创建项目；
    // 1.获取授权app_key,redirect_uri,回调函数;
    // 2.通过app_key和redirect_uri加载登录页面
    // 3.填写用户名和密码经微博认证后登录获取code  url.absoluteString 中包含code字段
    // 4.通过code换取access_token  ["access_token": 2.00iDbevFT5cemDae8dc7a6fc0DDeVr, "remind_in": 157679999, "uid": 5432590890, "expires_in": 157679999]
    // 5.通过access_token和uid获取用户信息

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航条
        loadNavigationBar()
        
        // 加载页面
        loadWebView()
    }
}

// MARK:- 设置界面
extension OAuthViewController {
    // 加载页面
    private func loadWebView() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"

        webView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
    }
    
    // 设置导航条
    private func loadNavigationBar() {
        title = "登录"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(OAuthViewController.closeOauthClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(OAuthViewController.fillInfoClick))
    }
    
    // 关闭按钮
    @objc private func closeOauthClick() {
        
    }
    
    // 填充用户名密码按钮  使用javaScript获取webView并修改属性
    @objc private func fillInfoClick() {
        let jsCode = "document.getElementById('userId').value='\(userid)';document.getElementById('passwd').value='\(passwd)';"
        webView.stringByEvaluatingJavaScriptFromString(jsCode)
    }
}

// MARK:- UIWebViewDelegate
extension OAuthViewController : UIWebViewDelegate {
    // webView开始加载
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    // webView加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // webView加载失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    // 准备加载webView时执行，返回值：布尔类型  获取request
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
  
        guard let url = request.URL else {
            return true
        }

        guard url.absoluteString.containsString("code=") else {
//            http://www.520it.com/?code=3839b897bdf0daf125ad6df8949d5358
            return true
        }
        
        let code = url.absoluteString.componentsSeparatedByString("code=").last!
        
        // 请求accessToken  在闭包中使用该类方法，必须加self
        self.loadAccessToken(code)
        
        return false
    }
    
    // MARK:- 抽取方法
    
    // 请求access_token
    func loadAccessToken(code : String) -> Void {
        NetworkTool.shareInstance.loadAccessToken(code) { (result, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let accountDict = result else {
                print("没有接收到授权数据")
                return
            }
            
            // result : Optional(["access_token": 2.00iDbevFT5cemDae8dc7a6fc0DDeVr, "remind_in": 157679999, "uid": 5432590890, "expires_in": 157679999])
            
            // 获取用户信息
            self.loadUserInfo(accountDict)
        }
    }
    
    // 获取用户信息
    func loadUserInfo(accountDict : [String : AnyObject]) -> Void {
        // 加载数据模型
        let account = UserAccount(dict: accountDict)
        
        // 通过access_token 和 uid 请求用户信息
        guard let access_token = account.access_token else {
            return
        }
        guard let uid = account.uid else {
            return
        }
        NetworkTool.shareInstance.loadUserInfo(access_token, uid: uid, finished: { (result, error) in
            if error != nil {
                print(error)
                return
            }
            // 返回用户信息
            guard let userInfoDict = result else {
                return
            }
            
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            // 将用户信息归档
            self.saveUserInfo(account)
            
            // 因为在第一次判断是否是登录用户时，已经创建了单例工具，但当时用户信息是nil的，所以必须此处给单例重新赋值
            UserAccountTool.shareInstance.account = account
            
            // 退出当前控制器  显示欢迎界面
            self.dismissViewControllerAnimated(false, completion: {
                UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
            })
        })
    }
    
    // 保存用户信息
    func saveUserInfo(account : UserAccount) -> Void {
        // 确保对象遵守了NSCoding协议并且实现协议方法
        
        // 保存对象
        NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountTool.shareInstance.accountPath)
    }
}