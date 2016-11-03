//
//  StatusViewModel.swift
//  WeiBo
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 lyl. All rights reserved.
//  对Status和User类的封装

import UIKit

class StatusViewModel: NSObject {
    // MARK:- 属性
    let status : Status?
    
    // 需要处理的属性
    // status模型
    var sourceText : String?      // 微博来源
    var createAtText : String?    // 创建时间
    var picURLs : [NSURL] = [NSURL]()    // 微博配图  转发微博图片
    
    // user模型
    var verifiedImage : UIImage?  // 认证
    var vipImage : UIImage?       // vip

    init(status : Status) {
        self.status = status
        
        // 处理来源
        if let source = status.source where source != "" {
            // 截取字符串 起始位置 截取长度
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            let length = (source as NSString).rangeOfString("</").location - startIndex
            
            sourceText = (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        }
        
        // 处理时间
        if  let createAt = status.created_at {
            createAtText = NSDate.createDateString(createAt)
        }
        
        // 处理认证图片
        let verifiedType = status.user?.verified_type ?? -1
        
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,4,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        // 处理微博配图   与   转发微博图片   
        // 如果有原带图片则显示原带图片 没有原带图片显示转发图片
        let picURLDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picURLDicts = picURLDicts {
            for picURLDict in picURLDicts {
                guard let picURLStr = picURLDict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(NSURL(string: picURLStr)!)
            }
        }
    }
}
