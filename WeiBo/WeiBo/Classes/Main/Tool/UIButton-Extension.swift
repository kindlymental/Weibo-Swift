//
//  UIButton-Extension.swift
//  WeiBo
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

extension UIButton {
    // MARK:- 便利构造函数
    convenience init (imageName : String,highImageName : String,bgImageName : String,highBgImageName : String) {
        self.init()
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: highImageName), forState: .Highlighted)
        
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(UIImage(named: highBgImageName), forState: .Highlighted)
    }
}
