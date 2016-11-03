//
//  PicCollectionCell.swift
//  WeiBo
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class PicCollectionCell: UICollectionViewCell {

    // 控件属性
    @IBOutlet weak var picImage: UIImageView!
    
    // 模型属性
    var picURL : NSURL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            picImage.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
