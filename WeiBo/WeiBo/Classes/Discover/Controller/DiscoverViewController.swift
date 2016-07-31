//
//  DiscoverViewController.swift
//  WeiBo
//
//  Created by mac on 16/7/26.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController {
    
    override func loadView() {
        isLogin = true

        super.loadView()
        tableView.backgroundColor = UIColor ( red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0 )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
