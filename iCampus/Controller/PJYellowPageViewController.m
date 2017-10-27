//
//  PJYellowPageViewController.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJYellowPageViewController.h"
#import "PJYellowPageTableView.h"
#import "ICNetworkManager.h"
#import "PJYellowPageDetailsViewController.h"


@interface PJYellowPageViewController () <PJYellowPageTableViewDelegate>

@end

@implementation PJYellowPageViewController
{
    PJYellowPageTableView *_kTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [PJHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = @"黄页";
    self.view.backgroundColor = [UIColor whiteColor];
    _kTableView = [PJYellowPageTableView new];
    _kTableView.tableDelegate = self;
    [self.view addSubview:_kTableView];
    
    [self getDataFromHttp];
}

- (void)getDataFromHttp {
    [PJHUD showWithStatus:@""];
    [[ICNetworkManager defaultManager] GET:@"Yellow Page Channel"
                                parameters:nil
                                   success:^(NSDictionary *dic) {
                                       NSArray *data = dic[@"resource"];;
                                       _kTableView.dataArr = [data mutableCopy];
                                       [PJHUD dismiss];
                                   }
                                   failure:^(NSError *error) {
                                       // error信息要怎么处理？
                                   }];
}

- (void)PJYellowPageTableViewCellClick:(NSDictionary *)dict {
    PJYellowPageDetailsViewController *vc = [PJYellowPageDetailsViewController new];
    vc.dataSource = dict;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
