//
//  PJYellowPageDetailsViewController.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJYellowPageDetailsViewController.h"
#import "PJYellowPageDetailsTableView.h"
#import "ICNetworkManager.h"

@interface PJYellowPageDetailsViewController ()

@end

@implementation PJYellowPageDetailsViewController {
    PJYellowPageDetailsTableView *_kTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = _dataSource[@"name"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    _kTableView = [PJYellowPageDetailsTableView new];
    [self.view addSubview:_kTableView];

    [self getDataFromHttp];
}

- (void)getDataFromHttp {
    [PJHUD showWithStatus:@""];
    NSDictionary *parameters = @{@"offset":@(1), @"filter":[NSString stringWithFormat:@"department=%@", _dataSource[@"department"]]};
    [[ICNetworkManager defaultManager] GET:@"Yellow Page"
                                parameters:parameters
                                   success:^(NSDictionary *dic) {
                                       NSArray *data = dic[@"resource"];;
                                       _kTableView.dataArr = [data mutableCopy];
                                       _kTableView.departmentName = _dataSource[@"name"];
                                       [PJHUD dismiss];
                                   }
                                   failure:^(NSError *error) {
                                       // error信息要怎么处理？
                                   }];
}


@end
