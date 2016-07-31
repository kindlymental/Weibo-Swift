//
//  UIButton-Extension.swift
//  WeiBo
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

enum ItemLeftOrRight {
    case ItemLeft
    case ItemRight
}

extension UIButton {
    // MARK:- 便利构造函数
    convenience init (imageName : String,highImageName : String,bgImageName : String,highBgImageName : String) {
        self.init()
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: highImageName), forState: .Highlighted)
        
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(UIImage(named: highBgImageName), forState: .Highlighted)
    }
    
    // NavigationBarButtonItem
    convenience init (title : String,itemDirection : ItemLeftOrRight) {
        self.init()

        setTitle(title, forState: .Normal)
        setTitleColor(UIColor.orangeColor(), forState: .Normal)
        setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        titleLabel?.font = UIFont.systemFontOfSize(14)
        frame.size = CGSizeMake(30, 30)
        
        switch itemDirection {
        case .ItemLeft:
            frame.origin = CGPointMake(10, 0)
        case .ItemRight:
            frame.origin = CGPointMake(screenW - bounds.size.width - 10, 0)
        }
    }
    
    convenience init (image : String,selectedImage : String,itemDirection : ItemLeftOrRight) {
        self.init()
        
        setImage(UIImage(named: image), forState: .Normal)
        setImage(UIImage(named: selectedImage), forState: .Highlighted)
        
        sizeToFit()
        
        switch itemDirection {
        case .ItemLeft:
            frame.origin = CGPointMake(10, 0)
        case .ItemRight:
            frame.origin = CGPointMake(screenW - bounds.size.width - 10, 0)
        }
    }
}
