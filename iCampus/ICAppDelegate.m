//
//  ICAppDelegate.m
//  iCampus
//
//  Created by Kwei Ma on 13-11-6.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICAppDelegate.h"
#import "MobClick.h"
#import "iCampus-Swift.h"
#import <SMS_SDK/SMSSDK.h>
#import "ICNetworkManager.h"
#import "ICGateViewController.h"

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

#define kAppId           @"89aUwAaCKo6rcax0lKY295"
#define kAppKey          @"HVnrqD1d4M8NpuAVPrhDH5"
#define kAppSecret       @"Vjr5wTOe7a9xwVVwgmdMpA"
#define UMAppkey         @"559536eb67e58ee8090040b2"

@interface ICAppDelegate()

@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;

@end

@implementation ICAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    // 启动友盟统计
//    [MobClick startWithAppkey:UMAppkey reportPolicy:BATCH channelId:nil];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
//    
//    // Override point for customization after application launch.
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ICNavigationBarBackground"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]}];
//    [[UINavigationBar appearance] setTranslucent:NO];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    
//    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret]; // 使用APPID/APPKEY/APPSECRENT创建个推实例
//    [self registerRemoteNotification]; // 注册APNS
//    [[UIApplication sharedApplication] cancelAllLocalNotifications]; //清理系统通知
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; //消除icon角标
    [SMSSDK registerApp:[ICNetworkManager defaultManager].SMSappKey withSecret:[ICNetworkManager defaultManager].SMSappSecret];// mod.com短信
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (![ICNetworkManager defaultManager].token || [[ICNetworkManager defaultManager].token isEqualToString:@""]) {
        self.controller = [[NSBundle mainBundle] loadNibNamed:@"ICLoginViewController2" owner:nil options:nil].firstObject;
        [self.window setRootViewController:self.controller];
    } else {
        self.controller = [[ICGateViewController alloc] init];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.controller];
        [self.window setRootViewController:self.navigationController];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self stopSdk]; // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
}

//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    
//    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret]; // [EXT] 重新上线
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}

// 向系统注册推送服务
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

// 使用APPID/APPKEY/APPSECRENT创建个推实例
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {
            NSLog(@"%@", [NSString stringWithFormat:@"%@", [err localizedDescription]]);
        } else {
            _sdkStatus = SdkStatusStarting;
        }
    }
}

// 注册APNS，申请deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", _deviceToken);
    
    // [3]:向个推服务器注册deviceToken
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:_deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:@""];
    }
    NSLog(@"%@", [NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理后台APN
    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    NSLog(@"%@", [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理远端APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    NSLog(@"%@", [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable]);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)setAliasWith:(NSString *)alias {
    if (_gexinPusher) {
        [_gexinPusher bindAlias:alias];
    }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        _clientId = nil;
    }
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    
//    [self stopSdk];
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    NSString *okString;
    NSString *titleString;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        okString = @"好";
        titleString = @"您收到一条通知！";
    } else {
        okString = @"OK";
        titleString = @"You receive a notification!";
    }
    NSLog(@"%@", [NSString stringWithFormat:@"%d, %@, %@", ++_lastPayloadIndex, [NSDate date], payloadMsg]);
    [[[UIAlertView alloc]initWithTitle:titleString
                               message:payloadMsg
                              delegate:nil
                     cancelButtonTitle:okString
                     otherButtonTitles:nil]show];
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSLog(@"%@", [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result]);
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"%@", [NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}

@end
