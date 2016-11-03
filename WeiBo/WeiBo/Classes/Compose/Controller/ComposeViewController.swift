//
//  CompostViewController.swift
//  WeiBo
//
//  Created by mac on 16/9/4.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit
import SnapKit

class ComposeViewController: UIViewController {

    // MARK:- 懒加载属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // toolBar约束
    @IBOutlet weak var toolBarConstraintBottom: NSLayoutConstraint!
    
    @IBOutlet weak var picPickerConstraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        // 监听键盘
        monitorKeyBoard()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
}

// MARK:- 导航条
extension ComposeViewController {
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.enabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    @objc private func closeItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sendItemClick() {
        Log("发送")
    }
}

// MARK:- UITextViewDelagate
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        // 设置placeHolder隐藏
        self.textView.placeHolderLabel.hidden = textView.hasText()
        // 设置发送按钮可点击
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
}

// MARK:- ToolBar
extension ComposeViewController {
    
    // 监听键盘的弹出和消失
    func monitorKeyBoard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardDidChangeFrame), name: UIKeyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardDidChangeFrame(notifacation : NSNotification) {
        // 获取键盘弹出动画时间
        let duration = notifacation.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 获取键盘位置
        let frame = (notifacation.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let y = frame.origin.y
        let marginY = screenH - y
        
        // 修改约束
        toolBarConstraintBottom.constant = marginY
        // 执行动画
        UIView.animateWithDuration(duration) { 
            self.view.layoutIfNeeded()
        }
    }
}

// MARK:- 上传图片
extension ComposeViewController {
    
    @IBAction func uploadBarButtonClick(sender: AnyObject) {
        picPickerConstraintHeight.constant = screenH * 0.65
        textView.resignFirstResponder()
        
        UIView.animateWithDuration(0.25) { 
            self.view.layoutIfNeeded()
        }
    }
}