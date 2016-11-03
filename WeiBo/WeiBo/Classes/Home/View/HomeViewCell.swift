//
//  HomeViewCell.swift
//  WeiBo
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit
import SDWebImage

let picItemMargin : CGFloat = 10
let cellX : CGFloat = 15

class HomeViewCell: UITableViewCell {
    // MARK:- 控件属性
    @IBOutlet weak var avatarImage: UIImageView!   // 头像
    @IBOutlet weak var verifiedImage: UIImageView!   // 认证
    @IBOutlet weak var screenNameLabel: UILabel!   // 昵称
    @IBOutlet weak var vipImage: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!    // 来源
    @IBOutlet weak var timeLabel: UILabel!      // 时间
    @IBOutlet weak var contentLabel: UILabel!   // 内容
    
    @IBOutlet weak var retweetedContentLabel: UILabel!                 // 转发微博内容
    @IBOutlet weak var picCollectionView: PicCollectionView!      // 配图collectionView
    
    @IBOutlet weak var retweetedBackView: UIView!       // 转发微博背景

    // MARK:- 约束属性
    @IBOutlet weak var textLabelWidthConstraint: NSLayoutConstraint!     // 微博正文宽度约束
    @IBOutlet weak var avatarImageXConstraint: NSLayoutConstraint!      // 头像的X值
    
    @IBOutlet weak var picViewWidthConstraint: NSLayoutConstraint!       // 配图宽度约束
    @IBOutlet weak var picViewHeightConstraint: NSLayoutConstraint!      // 配图高度约束
    
    @IBOutlet weak var picViewBottomConstraint: NSLayoutConstraint!       // 配图距离底部的约束
    
    @IBOutlet weak var retweetedTextTopConstraint: NSLayoutConstraint!      // 转发内容距离顶部的约束
    
    // 模型属性
    var statusModel : StatusViewModel? {
        didSet {
            // nil值校验
            guard let statusModel = statusModel else {
                return
            }
            // 赋值
            let url = NSURL(string: statusModel.status?.user?.profile_image_url ?? "")
            avatarImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default_small"))  // 头像
            
            verifiedImage.image = statusModel.verifiedImage   // 认证
            
            screenNameLabel.text = statusModel.status?.user?.screen_name   // 昵称
            screenNameLabel.textColor = statusModel.vipImage == nil ? UIColor.blackColor() : UIColor.orangeColor()       // 昵称颜色
            
            vipImage.image = statusModel.vipImage       // 会员图像
            
            timeLabel.text = statusModel.createAtText   // 时间
            
            contentLabel.text = statusModel.status?.text    // 正文
            
            // 通过图片个数计算picView的宽度和高度的约束
            let picViewSize = picCollectionViewConstraint(statusModel.picURLs.count)
            picViewWidthConstraint.constant = picViewSize.width
            picViewHeightConstraint.constant = picViewSize.height
            
            // 微博图片  或  转发微博配图  有微博图片显示微博图片 没有显示转发图片
            picCollectionView.picURLs = statusModel.picURLs
            
            // 转发微博正文
            if statusModel.status?.retweeted_status != nil {
                // 转发内容为空 转发内容lable距离上的约束为0
                retweetedTextTopConstraint.constant = 15
                
                let screenName = statusModel.status?.retweeted_status?.user?.screen_name ?? ""
                if let retweetedText = statusModel.status?.retweeted_status?.text{
                    retweetedContentLabel.text = "@" + "\(screenName)" + " :" + retweetedText
                }
                
                // 有转发微博 背景图片有颜色  无转发微博，背景图片无颜色
                retweetedBackView.hidden = false
            } else {
                retweetedContentLabel.text = nil
                
                retweetedBackView.hidden = true
                
                retweetedTextTopConstraint.constant = 0
            }
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 从xib中加载时调用，计算cell高度  设置一次的放在awakeFromNib即可
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置微博正文宽度约束   页面宽度-X*2=正文宽度
        textLabelWidthConstraint.constant = screenW - avatarImageXConstraint.constant * 2
    }
}

extension HomeViewCell {
    // 计算picCollectionView的约束  cell的大小
    private func picCollectionViewConstraint(count : Int) -> CGSize {
        // 没有配图 单张配图 四张配图 其他张配图（最多九张）
        
        // 图片大小
        let picViewWH = (screenW - 2 * avatarImageXConstraint.constant - 2 * picItemMargin) / 3
        
        picViewBottomConstraint.constant = 10
        
        // 没有配图
        if count == 0 {
            // 没有配图 配图距离底部的距离是0
            picViewBottomConstraint.constant = 0
            
            return CGSizeZero
        }
        // 单张配图
        // 实际开发中只需要设置cell的宽和高与图片的宽高一致就可以。但是新浪并没有给开发者返回宽高；需要下载图片显示
        if count == 1 {
            // 可以从内存或磁盘中取  内存效率更高；磁盘更有保证
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(statusModel?.picURLs.last?.absoluteString)
            
            // 注意：SDWebImage在下载图片的时候，会将图片的宽高变为原来的一半
//            return image.size     // 是原来图片大小的一半
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
        }
        
        // 四张配图
        if count == 4 {
            let picViewWH = picViewWH * 2 + picItemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 其他张配图
        // 行数
        let rows = (count - 1) / 3 + 1
        // 高度
        let picViewH = CGFloat(rows) * picViewWH + (CGFloat(rows) - 1) * picItemMargin
        // 宽度
        let picViewW = screenW - 2 * avatarImageXConstraint.constant
        return CGSize(width: picViewW, height: picViewH)
    }
}
