//
//  PJBusViewController.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJBusViewController.h"
#import "PJBusTableView.h"
#import "ICNetworkManager.h"
#import "PJBusDetailsViewController.h"


@interface PJBusViewController () <PJBusTableViewDelegate>

@end

@implementation PJBusViewController
{
    PJBusTableView *_kTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = @"校车";
    self.view.backgroundColor = [UIColor whiteColor];
    _kTableView = [PJBusTableView new];
    _kTableView.tableDelegate = self;
    [self.view addSubview:_kTableView];
    
    [self getDataFromHttp];
}

- (void)getDataFromHttp {
    [PJHUD showWithStatus:@""];
    [[ICNetworkManager defaultManager] GET:@"Bus"
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

- (void)PJBusTableViewCellClick:(NSDictionary *)dict {
    PJBusDetailsViewController *vc = [PJBusDetailsViewController new];
    vc.dataSource = dict;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
