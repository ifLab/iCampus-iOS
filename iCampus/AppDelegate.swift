//
//  AppDelegate.swift
//  iCampus
//
//  Created by Bill Hu on 2017/4/6.
//  Copyright © 2017年 ifLab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.maininit()
        
        return true
    }
    
    func maininit(){
        // init bmobSMS
        SMSSDK.registerApp(ICNetworkManager.default().smSappKey, withSecret: ICNetworkManager.default().smSappSecret)
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

        // init tabBarVC
        let tabBarC = ZKTabBarViewController.init()
        window?.rootViewController = tabBarC
        window?.makeKeyAndVisible()
        
        //判断是否登入，不登入弹出登入controller
        if ICNetworkManager.default().token == nil || ICNetworkManager.default().token == "" {
            let controller = Bundle.main.loadNibNamed("ICLoginViewController", owner: nil, options: nil)?.first
            tabBarC.present(controller as! UIViewController, animated: true, completion: nil)
        }
        
        // UM
        // open log
        UMSocialManager.default().openLog(true)
        // set key
        UMSocialManager.default().umSocialAppkey = "59d0e2f69f06fd268d00003e"
        UMConfigure.initWithAppkey("59d0e2f69f06fd268d00003e", channel: "App Store")
        let _ = MobClick.setScenarioType(eScenarioType(rawValue: 0)!)
        /* 设置第三方平台 */
        self.umengSharePlatforms()
        
        /* ZK Token刷新机制*/
        
        let file = NSHomeDirectory() + "/Documents/user.data"
        // 判断是否user.data文件是否存在
        if (FileManager.default.fileExists(atPath: file)){
            // 用户存在
            // 不是第一次登录
            // 获取用户
            let user:PJUser = NSKeyedUnarchiver.unarchiveObject(withFile: file) as! PJUser

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let lastTime = formatter.date(from: user.last_login_date)!
            let thisTime = Date()
            
            let timeInterval = thisTime.timeIntervalSince(lastTime)
            
            //时间差计算 3600 * 24
            if (timeInterval >= 3600 * 24){
                //超过一天未使用app
                let alertController = UIAlertController(title: "自动登录失败", message: "您已长时间未使用本APP，为了您的账号安全，请重新登录", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler:{
                    (UIAlertAction) -> Void in
                    //退出账号
                    let vc = Bundle.main.loadNibNamed("ICLoginViewController", owner: nil, options: nil)?.first
                    self.window?.rootViewController?.present(vc as! UIViewController, animated: true, completion: {
                        ICNetworkManager.default().token = ""   //如果没有此句代码，点击个人中心之后首先弹出的是CAS认证而不是账号登录
                        PJUser.logOut()
                    })
                })
                alertController.addAction(okAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }else{
            print("第一次登录")
        }
    }
    
    func umengSharePlatforms() {
        //微信
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wx0ef1e170ebdfdc4a", appSecret: "725104c3ba35661df23eb970ce57df47", redirectURL: nil)
        //新浪微博
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: "2449930345", appSecret: "089240e283d1250d819e923de41aabd0", redirectURL: nil)
        //QQ
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "1106660518", appSecret: "FNDO4FER7ayOhgSW", redirectURL: nil)
    }
    
    //友盟回调机制
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if  result {
            print("分享成功")
        }else{
            print("分享失败")
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let file = NSHomeDirectory() + "/Documents/user.data"
        if (FileManager.default.fileExists(atPath: file)){
            //用户存在
            //不是第一次登录
            //获取用户
            let user:PJUser = NSKeyedUnarchiver.unarchiveObject(withFile: file) as! PJUser
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let lastTime = formatter.date(from: user.last_login_date)!
            let thisTime = Date()
            
            let timeInterval = thisTime.timeIntervalSince(lastTime)
            
            //时间差计算 3600 * 24
            if (timeInterval <= 3600 * 24){
                //未超过一天
                //使用现有方法更新Session
                ICLoginManager.refreshToken() {
                    _ in
                }
            }
        }
    }
    
}
