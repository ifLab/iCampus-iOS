//
//  ZKTabBarViewController.m
//  iCampus
//
//  Created by 徐正科 on 2017/10/18.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "ZKTabBarViewController.h"
#import "PJYellowPageViewController.h"
#import "PJMapViewController.h"
#import "PJUserViewController.h"
#import "PJLostViewController.h"
#import "ICNetworkManager.h"
#import "CASBistu.h"
#import "iCampus-Swift.h"

@interface ZKTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation ZKTabBarViewController {
    NSArray *limitedTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor blackColor];
    // iOS 10起用
    self.tabBar.unselectedItemTintColor = RGB(150, 150, 150);
    self.delegate = self;
    
    //新闻
    [self addController:[[UINavigationController alloc] initWithRootViewController:[[ICNewsMainViewController alloc] init]] title:@"新闻" image:@"news"];
    //黄页
    [self addController:[[UINavigationController alloc] initWithRootViewController:[[PJYellowPageViewController alloc] init]] title:@"黄页" image:@"yellowPages"];
    //失物招领
    [self addController:[[UINavigationController alloc] initWithRootViewController:[[PJLostViewController alloc] init]] title:@"失物" image:@"LostFound"];
    //地图
    [self addController:[[UINavigationController alloc] initWithRootViewController:[[PJMapViewController alloc] init]] title:@"地图" image:@"map"];
    
    //个人中心
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"PJUserSB" bundle:nil];
    [self addController:[[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"PJUserViewController"]] title:@"我" image:@"userCenter"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNotLoginYetNotification) name:@"UserNotLoginYetNotification" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//将控制器添加到tabBar中
- (void)addController:(UIViewController *)navC title:(NSString *)title image:(NSString *)image {
    navC.tabBarItem.title = title;
    navC.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_nor", image]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC.tabBarItem.selectedImage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:navC];
}

//代理方法，监听是否登录
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //需要登录并且认证
    if ([ICNetworkManager defaultManager].token != nil && ![[ICNetworkManager defaultManager].token isEqualToString:@""]) {
        //已登录
        if ([viewController.tabBarItem.title isEqualToString:@"失物"]) {
            //查看失物需要CAS认证
            if (![CASBistu checkCASCertified] && [CASBistu showCASController]) {
                //CAS not certified
                ICCASViewController *controller = [[NSBundle mainBundle] loadNibNamed:@"ICCASViewController" owner:nil options:nil].firstObject;
                [self presentViewController:controller animated:YES completion:nil];
//                self.selectedIndex = 0;
            }
        }
        if ([viewController.tabBarItem.title isEqualToString:@"地图"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarDidSelectedNotification" object:nil userInfo:nil];
        }
        
    }else{
        //未登录
        self.selectedIndex = 0;
        ICLoginViewController *controller = [[NSBundle mainBundle] loadNibNamed:@"ICLoginViewController" owner:nil options:nil].firstObject;
        [self presentViewController:controller animated:YES completion:nil];
        return ;
    }
}

- (void)userNotLoginYetNotification{
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
