//
//  UserAccountTool.swift
//  WeiBo
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

// 不使用KVC 可以不继承NSObject
class UserAccountTool {
    // MARK:- 将tool类设计为单例
    static let shareInstance : UserAccountTool = UserAccountTool()
    
    // 用户模型
    var account : UserAccount?
    
    // 计算属性 相当于一个方法
    var accountPath : String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        return (accountPath as NSString).stringByAppendingPathComponent("account.plist")
    }
    
    // 重写init方法，创建UserAccountTool 即可获取沙盒模型
    init () {
        // 读取数据
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }
    
    // 判断是否存在登录用户并且是否过期
    var isLogin : Bool {
        if account == nil {
            return false
        }
        guard let expiresDate = account?.expires_date else {
            return false
        }
        
        // 没有过期 降序  过期 升序
        return expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending
    }
}
