//
//  PicCollectionView.swift
//  WeiBo
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {
    
    // cell 间隔
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    // cell 的size
    let picViewWH = (screenW - 2 * cellX - 2 * picItemMargin) / 3
    
    // cell data
    var picURLs : [NSURL] = [NSURL]() {
        didSet {
            self.reloadData()
        }
    }
    
    // 设置数据源 一次就好
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
        
        self.backgroundColor = UIColor.clearColor()
        
        // 注册cell 或使用HomeViewCell.xib中的collectionView 设置标识
        self.registerNib(UINib(nibName: "PicCollectionCell",bundle: nil), forCellWithReuseIdentifier: "PicView")
    }
}

// MARK:- colectionView dataSource
extension PicCollectionView : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PicView", forIndexPath: indexPath) as!PicCollectionCell
  
        // 给cell赋值
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout
extension PicCollectionView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        // 设置图片大小
        // 单张图片因为是下载下来的，使用SDWebImage下载下来的图片的size会变为原来的1/2，所以需要乘以2返回 从磁盘取出来即可
        let url : NSURL = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url.absoluteString)
        if image != nil {
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
        }
        // 非单张图片  跟cell的大小一致
        return CGSize(width: picViewWH, height: picViewWH)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
}
