//
//  VisitorView.swift
//  WeiBo
//
//  Created by mac on 16/7/28.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    
    // MARK:- 加载xib文件 类方法
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).first as! VisitorView
    }

    // MARK:- 控件属性
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    // 转盘
    @IBOutlet weak var rotationView: UIImageView!
    // 图标
    @IBOutlet weak var iconView: UIImageView!
    // 提示文字
    @IBOutlet weak var tipLabel: UILabel!
    
    // MARK:- 重新加载xib中上述属性的显示效果
    func reloadVisitorView(iconName iconName : String,title : String) -> Void {
        rotationView.hidden = true
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
    }
    
    // MARK:- imageView旋转动画
    func addImageViewRotationAnimation() -> Void {
        let rotationAnim : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 20
        rotationAnim.removedOnCompletion = false
        
        rotationView.layer.addAnimation(rotationAnim, forKey: nil)
    }
}
