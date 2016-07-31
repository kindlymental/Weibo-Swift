//
//  NavigationViewController.swift
//  WeiBo
//
//  Created by mac on 16/7/30.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationBar背景颜色
        navigationBar.barTintColor = UIColor.whiteColor()
        // navigationBarItem文字特性
        let shadow = NSShadow()
        shadow.shadowColor = UIColor ( red: 0.498, green: 0.498, blue: 0.498, alpha: 1.0 )
        shadow.shadowOffset = CGSizeMake(0, 0)
        
        let attr : NSDictionary! = [NSForegroundColorAttributeName:UIColor ( red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0 ),NSFontAttributeName:UIFont(name: "Verdana",size: 16.0)!,
                                    NSShadowAttributeName:shadow]

        self.navigationBar.titleTextAttributes = attr as? [String : AnyObject]
    }

}
