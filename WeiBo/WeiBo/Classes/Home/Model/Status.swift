//
//  Status.swift
//  WeiBo
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class Status: NSObject {
    // MARK:- 属性
    var created_at : String?  // 创建时间  需处理
    var source : String?   // 微博来源  需处理
    
    var text : String? // 正文
    var mid : Int = 0  // 微博ID
    var pic_urls : [[String : String]]?      // 微博配图 字典数组  需处理
    
    // 用户属性
    var user : User?
    
    // 转发微博
    var retweeted_status : Status?
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        // 将用户字典转化为用户模型
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = User(dict: userDict)
        }
        
        // 将转发微博字典转化为模型
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : AnyObject] {
            retweeted_status = Status(dict: retweetedStatusDict)
        }
    }
    
    // 防止KVC赋值出错
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
