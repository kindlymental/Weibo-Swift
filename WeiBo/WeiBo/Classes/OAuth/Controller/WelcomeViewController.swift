//
//  WelcomeViewController.swift
//  WeiBo
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // MARK:- 拖线属性
     
    @IBOutlet weak var iconViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var iconView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let profileURL = UserAccountTool.shareInstance.account?.avatar_large
        // ?? : 如果??前面的可选类型有值，将前面的可选类型进行解包  如果??前面的可选类型为nil，则使用""
        let url = NSURL(string: profileURL ?? "")
        iconView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default_big"))
        
        // 动画
        moveViewUpAnimation()
    }

    // 向上移动动画
    func moveViewUpAnimation() -> Void {
        iconViewBottomConstraint.constant = screenH - 150
        
        /**
         执行动画，拥有弹性效果  iOS7之后开始使用，是对UIDynamicAnimator  UISnapBehavior的封装
         
         - parameter <Tduration:             
             动画延迟
         - parameter delay:                  
             动画时间
         - parameter usingSpringWithDamping: Damping:阻力系数，阻力系数越大，弹性越小  iOS对临界值的处理不太好  0和1尽量不要使
         - parameter initialSpringVelocity: 
             初始化速度
         - parameter options:                
             参数 枚举类型  如果在Swift中如果枚举类型想要使用默认的  可以使用[]
         - parameter animations:             
             执行动画
         - parameter completion:             
             动画执行完block
         */
        UIView.animateWithDuration(2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options:[] , animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                // 进入主程序
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
}
