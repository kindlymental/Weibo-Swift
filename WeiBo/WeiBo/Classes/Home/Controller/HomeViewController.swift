//
//  HomeViewController.swift
//  WeiBo
//
//  Created by mac on 16/7/26.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    
    private func userIsLogin() {
        // 该页面游客身份有登录和注册按钮
        hasBarButtonItem = false

    }
    
    override func loadView() {
        userIsLogin()
        
        super.loadView()
    }
    
    // MARK:- 懒加载属性
    private lazy var titleView : TitleView = TitleView()
    
    // 因为home控制器引用animator，animator引用闭包，闭包又调用self（Home）控制器，所以会产生循环引用
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { [weak self] (isPresented) in
        // 在闭包中如果使用当前对象的属性或调用方法，必须加self    
        // 如果在一个函数中如果出现歧义属性需要加self，闭包中使用当前对象属性或方法需要加self
        self?.titleView.selected = isPresented
    }
    
    // 首页模型
    private lazy var statusModels : [StatusViewModel] = [StatusViewModel]()
    
    // 提示加载微博条数
    private lazy var tipLabel : UILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 访客视图
        if !isLogin {
            // 给rotationView添加动画效果
            visitorView.addImageViewRotationAnimation()
            return
        }
        
        // 用户视图
        loadNavigationBar()
        
        // tipLabel
        setupTipLabel()
        
        // 设置tableView属性
        tableViewPropertySetting()
        
        // 请求数据
        loadStatusesData(true)
        
        // 下拉刷新 上拉刷新
        loadRefreshHeaderView()
        loadRefreshFooterView()
    }
    
}

// MARK:- 搭建首页界面 设置titleView
extension HomeViewController { 
    // 导航条 titleView  初始化
    private func loadNavigationBar() {
    
        let leftBarButton : UIButton = UIButton(image: "navigationbar_friendattention",selectedImage: "navigationbar_friendattention_highlighted",itemDirection: .ItemLeft)
        leftBarButton.addTarget(self, action: #selector(HomeViewController.leftBarButtonClick), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        let rightBarButton : UIButton = UIButton(image: "navigationbar_pop",selectedImage: "navigationbar_pop_highlighted",itemDirection: .ItemRight)
        rightBarButton.addTarget(self, action: #selector(HomeViewController.rightBarButtonClick), forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        // titleView
//        print(UserAccountTool.shareInstance.account?.screen_name)
        titleView.setTitle(UserAccountTool.shareInstance.account?.screen_name, forState: .Normal)
        titleView.addTarget(self, action: #selector(HomeViewController.titleViewClick), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleView
    }
    
    @objc private func leftBarButtonClick() {
        
    }
    
    @objc private func rightBarButtonClick() {
        
    }
    
    private func setupTipLabel() {
        navigationController?.navigationBar.addSubview(tipLabel)
//        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        tipLabel.frame = CGRect(x: 0, y: 44, width: screenW, height: 34)
        
        tipLabel.backgroundColor = UIColor ( red: 1.0, green: 0.502, blue: 0.0, alpha: 1.0 )
        
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.font = UIFont.systemFontOfSize(13)
        
        tipLabel.alpha = 0;
    }
    
    // 点击titleView触发事件
    @objc private func titleViewClick() {
        // 通过监听动画是弹出和消失来确定箭头朝上还是朝下
        
        
        // 自定义转场
        let popoverVc = PopoverViewController()
        
        // 设置modal控制器属性，使得modal出来控制器后，后面的控制器不会消失
        popoverVc.modalPresentationStyle = .Custom
        
        // 自定义转场
        let containerWidth : CGFloat = 160
        
        popoverAnimator.presentedFrame = CGRect(x: (screenW - containerWidth)*0.5, y: 64-10, width: containerWidth, height: 200)
        popoverVc.transitioningDelegate = popoverAnimator
        
        presentViewController(popoverVc, animated: true, completion: nil)
    }
}

// MARK:- 刷新
extension HomeViewController {
    private func loadRefreshHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatusesData))
        
        header.setTitle("下拉刷新", forState: .Idle)
        header.setTitle("松开更新", forState: .Pulling)
        header.setTitle("加载中...", forState: .Refreshing)
        
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }
    
    private func loadRefreshFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector( HomeViewController.loadMoreStatuses))
    }
}

// MARK:- 请求网络数据
extension HomeViewController {
    
    // 加载最新消息
    @objc private func loadNewStatusesData() {
        loadStatusesData(true)  // 下拉刷新
    }
    
    @objc private func loadMoreStatuses() {
        loadStatusesData(false) // 上拉刷新
    }
    
    // 加载首页数据
    private func loadStatusesData(isNewData : Bool) {
        // 请求since_id max_id
        var since_id = 0
        var max_id = 0
        if isNewData {  // 下拉刷新
            since_id = statusModels.first?.status?.mid ?? 0
        } else {  // 上拉刷新
            max_id = statusModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        // 加载微博数据
        NetworkTool.shareInstance.loadStatusDatas(since_id, max_id: max_id) { (result, error) in
            // 错误校验
            if error != nil {
                print(error)
                return
            }
            
            // 获取可选类型中的数据
            guard let dataArray = result else {
                return
            }
            
            // 遍历字典数组
            var tempModel = [StatusViewModel]()
            for statusDict in dataArray {
                // 字典转模型
                let status = Status(dict: statusDict)
                let statusModel = StatusViewModel(status: status)
//                self.statusModels.append(statusModel)   拼接到最后  都不正确
//                self.statusModels.insert(statusModel, atIndex: 0)  都不正确
                tempModel.append(statusModel)
            }
            // 把新加载的数据添加到数组中去 下拉刷新将数据加到前面，上拉刷新加到后面
            if isNewData {
                self.statusModels = tempModel + self.statusModels
            } else {
                self.statusModels += tempModel
            }
            
            // 缓存图片
            self.cacheImages(self.statusModels)
        }
    }
    
    // 缓存图片
    private func cacheImages(statusModels : [StatusViewModel]) {
        let group = dispatch_group_create()
        
        // 缓存
        for statusModel in statusModels {
            for picURL in statusModel.picURLs {
                
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    // 下载图片完成  异步下载
                    dispatch_group_leave(group)
//                    print("下载图片")
                })
            }
        }
        // 刷新表格
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            
            self.tableView.reloadData()
//            print("刷新数据")
            
            // 停止刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            // 显示提示的label
            self.showTipLabel(statusModels.count)
        }
    }
    
    // 显示tipLabel
    private func showTipLabel(count : Int) {
        tipLabel.text = count == 0 ? "没有新微博" : "\(count)条新微博"
        
        UIView.animateWithDuration(1.0, delay:0, options:[], animations: {
//            self.tipLabel.frame.origin.y = 44
            self.tipLabel.alpha = 1;
            }) { (_) in
                UIView.animateWithDuration(1.0, delay: 1, options: [], animations: {
//                    self.tipLabel.frame.origin.y = 10
                    self.tipLabel.alpha = 0;
                    }, completion: { (_) in

                })
        }
    }
}

// MARK:- tableView
extension HomeViewController {
    
    private func tableViewPropertySetting() {
        self.tableView.registerNib(UINib(nibName:"HomeViewCell",bundle: nil), forCellReuseIdentifier: "HomeCell")
        // 去除分割线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 使用autoLayout自适应tableViewCell高度
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : HomeViewCell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! HomeViewCell

        cell.statusModel = statusModels[indexPath.row]
        
        return cell
    }
}
