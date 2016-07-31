//
//  AppDelegate.swift
//  WeiBo
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // tabBar 背景颜色
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        // navigationBar 文字颜色
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        window?.rootViewController = TabBarViewController()
//        window?.makeKeyAndVisible()
        
//        createObjectByString()
        
        return true
    }
}

// 定义全局变量
let screenW = UIScreen.mainScreen().bounds.size.width
let screenH = UIScreen.mainScreen().bounds.size.height

// 使用字符串创建对象  (没用)
func createObjectByString() {
    let vc : UITabBarController = TabBarViewController()
    print(vc)
    
    let fileName : String? = "TabBarViewController"
    
    // 获取命名空间
    guard let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else {
        return
    }
    
    guard let filePath : String? = "\(nameSpace).\(fileName)" else {
        return
    }
    
    guard fileName != nil else {
        return
    }
    
    guard let childClass = NSClassFromString(nameSpace + "." + fileName!) else {
        return
    }

    print(childClass)
}

/**
 打印显示内容  全局函数：不在某个类中的函数都是全局函数 一般都写在AppDelegate文件中
 
 - parameter message:  打印内容
 - parameter file:     文件名称
 - parameter funcName: 方法名称
 - parameter lineNum:  打印的内容行数
 */
func Log<T>(message : T ,file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
//    #if DEBUG
    
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName)-\(funcName)-\(lineNum):\(message)")
        
//    #endif
}

