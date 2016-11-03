//
//  ComposeTextView.swift
//  WeiBo
//
//  Created by mac on 16/9/4.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    // MARK:- 懒加载属性
    lazy var placeHolderLabel : UILabel = UILabel()
    
    // 加载控件时调用 如果控件从xib中加载先执行coder aDecoder 再调用awakeFromNib 
    // 规范：如果添加子控件 建议使用coder方法  如果对控件进行初始化操作建议使用awakeFromNib
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension ComposeTextView {
    private func setupView() {
        addSubview(placeHolderLabel)
        
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(10)
        }
        
        placeHolderLabel.text = "分享微博"
        placeHolderLabel.textColor = UIColor.lightGrayColor()
        placeHolderLabel.font = font
        
        // 设置内容内边距
        textContainerInset = UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 0)
    }
}