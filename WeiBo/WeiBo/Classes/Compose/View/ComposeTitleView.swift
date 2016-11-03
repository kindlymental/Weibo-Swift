//
//  ComposeTitleView.swift
//  WeiBo
//
//  Created by mac on 16/9/4.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    // MARK:- 懒加载
    private lazy var titleLabel : UILabel = UILabel()
    private lazy var nameLabel : UILabel = UILabel()
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ComposeTitleView {
    private func setupView() {
        addSubview(titleLabel)
        addSubview(nameLabel)
        
        // 使用约束设置frame
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(self.snp_top)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
        }
        
        titleLabel.font = UIFont.systemFontOfSize(15)
        nameLabel.font = UIFont.systemFontOfSize(13)
        nameLabel.textColor = UIColor ( red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0 )
        
        titleLabel.text = "发微博"
        nameLabel.text = UserAccountTool.shareInstance.account?.screen_name
    }
}