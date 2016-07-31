//
//  TitleView.swift
//  WeiBo
//
//  Created by mac on 16/7/30.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class TitleView: UIButton {
    
    override init(frame:CGRect) {
        super.init(frame : frame)
        
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        sizeToFit()
    }
    
    // swift中规定：重写控件的init或init(frame)方法，必须重写init?方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置title和image的位置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }
}
