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
        if ICNetworkManager.default().token == nil || ICNetworkManager.default().token == "" {
            let controller = Bundle.main.loadNibNamed("ICLoginViewController", owner: nil, options: nil)?.first as! ICLoginViewController
            window?.rootViewController = controller
        } else {
            ICLoginManager.refreshToken() {
                [weak self] message in
                if let self_ = self {
                    let controller = Bundle.main.loadNibNamed("ICLoginViewController", owner: nil, options: nil)?.first as! ICLoginViewController
                    self_.navigationController?.present(controller, animated: false, completion: nil)
                }
            }
            let controller = ICGateViewController(collectionViewLayout: UICollectionViewFlowLayout())
            navigationController = UINavigationController(rootViewController: controller)
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
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

