//
//  UserAccount.swift
//  WeiBo
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class UserAccount: NSObject ,NSCoding{
    // 授权属性
    var access_token : String?
    var expires_in : NSTimeInterval = 0.0 {
        didSet {
            // 监听过期时间，一旦改变立即赋值
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    var uid : String?
    
    // 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    // 为了防止使用KVC产生的对于未接受的变量，重写setValue方法
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK:- 遍历类的属性 重写description属性
    override var description: String {
        return dictionaryWithValuesForKeys(["access_token","expires_date","uid","screen_name","avatar_large"]).description
    }
    
    // 过期日期
    var expires_date : NSDate?
    
    // 用户信息
    var screen_name : String?   // 昵称
    var avatar_large : String?   // 头像
 
    // MARK:- 归档&解档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token,forKey: "access_token")
        aCoder.encodeObject(uid,forKey: "uid")
        aCoder.encodeObject(expires_date,forKey: "expires_date")
        aCoder.encodeObject(avatar_large,forKey: "avatar_large")
        aCoder.encodeObject(screen_name,forKey: "screen_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
}
