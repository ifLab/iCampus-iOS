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
        SMSSDK.registerApp(ICNetworkManager.default().smSappKey, withSecret: ICNetworkManager.default().smSappSecret)
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        
        //4.0版本 主要架构变更为TabBarController
        let tabBarC = ZKTabBarViewController.init()
        window?.rootViewController = tabBarC
        window?.makeKeyAndVisible()

        //判断是否登入，不登入弹出登入controller
        if ICNetworkManager.default().token != nil && ICNetworkManager.default().token != "" {
            if !CASBistu.checkCASCertified() && CASBistu.showCASController() {
                let controller = Bundle.main.loadNibNamed("ICCASViewController", owner: nil, options: nil)?.first
                tabBarC.present(controller as! UIViewController, animated: true, completion: nil)
            }
        }else{
            let controller = Bundle.main.loadNibNamed("ICLoginViewController", owner: nil, options: nil)?.first
            tabBarC.present(controller as! UIViewController, animated: true, completion: nil)
        }
        
        //集成 友盟分享
        
        /* 打开日志 */
        UMSocialManager.default().openLog(true)
        
        /* 设置友盟appkey */
        UMSocialManager.default().umSocialAppkey = "59d0e2f69f06fd268d00003e"
        UMConfigure.initWithAppkey("59d0e2f69f06fd268d00003e", channel: "App Store")
        let _ = MobClick.setScenarioType(eScenarioType(rawValue: 0)!)
        
        /* 设置第三方平台 */
        self.umengSharePlatforms()
        
        //end
        
        
        /* ZK Token刷新机制*/
        
        let file = NSHomeDirectory() + "/Documents/user.data"
        //判断是否user.data文件是否存在
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
            if (timeInterval >= 3600 * 24){
                //超过一天未使用app
                let alertController = UIAlertController(title: "自动登录失败", message: "您已长时间未使用本APP，为了您的账号安全，请重新登录", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler:{
                    (UIAlertAction) -> Void in
                })
                alertController.addAction(okAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                //退出账号
                
                
                let vc = Bundle.main.loadNibNamed("ICLoginViewController", owner: nil, options: nil)?.first
                tabBarC.present(vc as! UIViewController, animated: true, completion: {
                    ICNetworkManager.default().token = ""   //如果没有此句代码，点击个人中心之后首先弹出的是CAS认证而不是账号登录
                    PJUser.logOut()
                    tabBarC.select(0)
                })
            }
        }else{
            print("第一次登录")
        }
        
    }
    
    //设置友盟第三方账号
    func umengSharePlatforms() {
        //微信
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wx0ef1e170ebdfdc4a", appSecret: "725104c3ba35661df23eb970ce57df47", redirectURL: nil)
        //新浪微博
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: "2449930345", appSecret: "089240e283d1250d819e923de41aabd0", redirectURL: nil)
        //QQ 暂未申请
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
        NotificationCenter.default.post(name: NSNotification.Name("NewsShouldCacheNotification"), object: nil)
    }
    
}
