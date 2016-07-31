//
//  MessageViewController.swift
//  WeiBo
//
//  Created by mac on 16/7/26.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.reloadVisitorView(iconName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }

}
