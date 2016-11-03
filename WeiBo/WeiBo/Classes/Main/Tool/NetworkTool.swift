//
//  NetworkTool.swift
//  AFNetworing封装
//
//  Created by mac on 16/7/31.
//  Copyright © 2016年 lyl. All rights reserved.
//

import UIKit
import AFNetworking

// 定义枚举类型标识传输方式
enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTool: AFHTTPSessionManager {
    // 创建单例 let是线程安全的  使用闭包创建对象
    static let shareInstance : NetworkTool = {
        let tools = NetworkTool()
        // 添加json序列化格式
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
}

// MARK:- 封装请求方法
extension NetworkTool {
    func request(methodType : RequestType,urlString : String,params : [String : AnyObject],finished : (result : AnyObject?, error : NSError?) -> ()) -> Void {
        if methodType == .GET {
            GET(urlString, parameters: params, progress: nil, success: { (task : NSURLSessionDataTask, result : AnyObject?) in
                finished(result: result, error: nil)
            }) { (task : NSURLSessionDataTask?, error : NSError) in
                print(error)
            }
        } else {
            POST(urlString, parameters: params, progress: nil, success: { (task : NSURLSessionDataTask, result : AnyObject?) in
                finished(result: result, error: nil)
            }) { (task : NSURLSessionDataTask?, error : NSError) in
                print(error)
            }
        }
    }
}

// MARK:- 请求AccessToken
extension NetworkTool {
    func loadAccessToken (code : String,finished : (result : [String : AnyObject]?,error : NSError?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 2.获取请求的参数
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
        
        // 3.发送网络请求
        request(.POST, urlString: urlString, params: parameters) { (result, error) in
            finished(result: result as? [String:AnyObject], error: error)
        }
    }
}

// MARK:- 请求用户信息
extension NetworkTool {
    func loadUserInfo(access_token : String,uid : String,finished : (result : [String : AnyObject]?,error : NSError?) -> ()) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["access_token" : access_token,"uid" : uid]
        
        request(.GET, urlString: urlString, params: params) { (result, error) in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
}

// MARK:- 请求首页数据
extension NetworkTool {
    func loadStatusDatas(since_id : Int,max_id : Int,finished : (result : [[String : AnyObject]]?,error : NSError?) -> ()) -> Void {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // 2.获取请求的参数
        let accessToken = (UserAccountTool.shareInstance.account?.access_token)!

        let parameters = ["access_token" : accessToken, "since_id" : "\(since_id)", "max_id" : "\(max_id)"]
        
        request(.GET, urlString: urlString, params: parameters) { (result, error) in
            guard let dataDict = result as? [String : AnyObject] else {
                finished(result: nil, error: error)
                return
            }
            finished(result: dataDict["statuses"] as? [[String : AnyObject]], error: error)
//               Log(result!)
        }
    }
}