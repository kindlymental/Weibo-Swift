//
//  User.swift
//  WeiBo
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class User: NSObject {
    // MARK:- 用户属性
    var profile_image_url : String?  // 用户头像
    var screen_name : String?      // 用户昵称
    var verified_type : Int = -1   // 认证类型 
    var mbrank : Int = 0          // 会员等级
    
    // MARK:- 用户数据处理
    var verifiedImage : UIImage?  // 需处理
    var vipImage : UIImage?    // 需处理
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
