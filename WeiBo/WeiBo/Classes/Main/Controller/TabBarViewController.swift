//
//  TabBarViewController.swift
//  WeiBo
//
//  Created by mac on 16/7/26.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    // MARK:- 懒加载属性
    private lazy var selectedImageNames = ["tabbar_home","tabbar_message_cener","","tabbar_discover","tabbar_profile"]
    
    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", highImageName: "tabbar_compose_icon_add_highlighted", bgImageName: "tabbar_compose_button", highBgImageName: "tabbar_compose_button_highlighted")
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addComposeBtn()
        
    }
    
    override func viewWillAppear(animated: Bool) {
//        setupTabBarItemImage()
        setupTabBarItemTitle()
    }
    
}

// MARK:- 界面设置
extension TabBarViewController {
    // MARK:- 设置Tabbar  (SB中已设置) 在此处没有调用
    private func setupTabBarItemImage() {
        // 遍历tabbar，设置tabbar的文字颜色和图片颜色  没有起作用
        for i in 0..<tabBar.items!.count {
            let item = tabBar.items![i]
            
            item.selectedImage = UIImage(named: selectedImageNames[i] + "_highlighted")
            
            // 设置compose item不可交互 使用自定义的按钮
            if i == 2 {
                item.enabled = false
                continue
            }
        }
    }
    
    // MARK:- 设置Tabbar的title颜色
    private func setupTabBarItemTitle() {
        // 设置tabbarItem的选中状态文字颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orangeColor()], forState: .Selected)

    }
    
    // MARK:- 添加compose按钮
    // 注意1：如果点击按钮 没有显示高亮时图片，是因为按钮的上方是tabBarItem，遮挡了按钮，只要设置tabBarItem的enable为false即可
    private func addComposeBtn() {
        tabBar.addSubview(composeBtn)
        
        // 必须写 相当于设置按钮的尺寸 因为已经有图片了所以宽高确定了
        composeBtn.sizeToFit()
        
        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height * 0.5)
        
        composeBtn.addTarget(self, action:#selector(TabBarViewController.composeBtnClick), forControlEvents: .TouchUpInside)
    }
}

// MARK:- 事件监听
extension TabBarViewController {
    // MARK:- compose按钮监听
    @objc private func composeBtnClick() {
        
    }
}
