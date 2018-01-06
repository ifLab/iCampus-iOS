//
//  PJUserViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/3.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJUserViewController.h"
#import "PJAboutViewController.h"
#import "PJMyLostViewController.h"
#import "PJUserAandCViewController.h"
#import "ICNetworkManager.h"
#import "iCampus-Swift.h"

@interface PJUserViewController ()

@end

@implementation PJUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [PJUser currentUser].first_name];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userDidLogin) name:@"UserDidLoginNotification" object:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self toMyLost];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self toAandC];
        }
        if (indexPath.row == 1) {
            [self toAbout];
        }
    }
}

- (void)userDidLogin{
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [PJUser currentUser].first_name];
}

-(void)logout{
    ICLoginViewController *vc = [[NSBundle mainBundle] loadNibNamed:@"ICLoginViewController" owner:nil options:nil].firstObject;
    [self presentViewController:vc animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
        [ICNetworkManager defaultManager].token = @"";
        [PJUser logOut];
        
        self.tabBarController.selectedIndex = 0;
    }];
}

- (void)toAandC {
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJUserAandCSB" bundle:nil];
    PJUserAandCViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJUserAandCViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
    
- (void)toMyLost {
    PJMyLostViewController *vc = [PJMyLostViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toAbout {
    PJAboutViewController *vc = [PJAboutViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return false;
}

@end
