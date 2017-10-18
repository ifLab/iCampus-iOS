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
        // Override point for customization after application launch.
        SMSSDK.registerApp(ICNetworkManager.default().smSappKey, withSecret: ICNetworkManager.default().smSappSecret)
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        if ICNetworkManager.default().token != nil && ICNetworkManager.default().token != "" {
            ICLoginManager.refreshToken() {
                _ in
            }
        }
        //        let controller = ICGateViewController(collectionViewLayout: UICollectionViewFlowLayout())
        //        navigationController = UINavigationController(rootViewController: controller)
        //        window?.rootViewController = navigationController
        
        //4.0版本 主要架构变更为TabBarController
        let tabBarC = ZKTabBarViewController.init()
        window?.rootViewController = tabBarC
        window?.makeKeyAndVisible()
        
        //集成 友盟分享
        
        /* 打开日志 */
        UMSocialManager.default().openLog(true)
        
        /* 设置友盟appkey */
        UMSocialManager.default().umSocialAppkey = "59d0e2f69f06fd268d00003e"
        
        /* 设置第三方平台 */
        self.umengSharePlatforms()
        //end
        return true
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

