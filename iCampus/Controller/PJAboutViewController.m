//
//  PJAboutViewController.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJAboutViewController.h"
#import "ICNetworkManager.h"
#import "PJAboutTableView.h"
#import "PJAboutDetailsViewController.h"

@interface PJAboutViewController () <PJAboutTableViewDelegate>

@end

@implementation PJAboutViewController {
    PJAboutTableView *_kTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];
    _kTableView = [PJAboutTableView new];
    _kTableView.tableDelegate = self;
    [self.view addSubview:_kTableView];
    
    [self getDataFromHttp];
}

- (void)getDataFromHttp {
    [PJHUD showWithStatus:@""];
    [[ICNetworkManager defaultManager] GET:@"About"
                                parameters:nil
                                   success:^(NSDictionary *dic) {
                                       NSArray *data = dic[@"resource"];;
                                       _kTableView.dataArr = [data mutableCopy];
                                       [PJHUD dismiss];
                                   } failure:^(NSError *error) {
                                       // error信息要怎么处理？
                                   }];
}

- (void)PJAboutTableViewCellClick:(NSDictionary *)dict {
    PJAboutDetailsViewController *vc = [PJAboutDetailsViewController new];
    vc.dataSource = dict;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
