//
//  PJLostViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJLostViewController.h"
#import "PJNewLostViewController.h"
#import "PJLostTableView.h"
#import "ICNetworkManager.h"
#import "IDMPhotoBrowser.h"

@interface PJLostViewController () <PJLostTableViewDelegate>

@end

@implementation PJLostViewController
{
    PJLostTableView *_kTableView;
    
    int page;
    NSString *_freshFlag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [PJHUD dismiss];
}

- (void)initView {
    page = 0;
    _freshFlag = headerRefresh;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"失物招领";
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _kTableView = [PJLostTableView new];
    [self.view addSubview:_kTableView];
    _kTableView.tableDelegate = self;
    _kTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headfresh)];
    _kTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footfresh)];
    
    [self getDataFromHttp];
}

- (void)rightItemClick {
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJNewLost" bundle:nil];
    PJNewLostViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJNewLostViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getDataFromHttp {
    [PJHUD showWithStatus:@""];
    NSDictionary *paramters = @{@"offset":@(page*10),
                                @"filter":@"isFound=false"};
    [[ICNetworkManager defaultManager] GET:@"Lost"
                                parameters:paramters
                                   success:^(NSDictionary *dic) {
                                       [_kTableView.mj_header endRefreshing];
                                       [_kTableView.mj_footer endRefreshing];
                                       [PJHUD dismiss];
                                       NSArray *data = dic[@"resource"];
                                       if (data.count) {
                                           if ([_freshFlag isEqualToString:headerRefresh]) {
                                               [_kTableView.dataArr removeAllObjects];
                                           }
                                           _kTableView.dataArr = [data mutableCopy];
                                       } else {
                                           [PJHUD showErrorWithStatus:@"没有数据了"];
                                       }
                                      
                                   }
                                   failure:^(NSError *error) {
                                       // error信息要怎么处理？
                                   }];
}

- (void)headfresh {
    page = 0;
    _freshFlag = headerRefresh;
    [self getDataFromHttp];
}

- (void)footfresh {
    page ++;
    _freshFlag = footerRefresh;
    [self getDataFromHttp];
}

- (void)tableViewClick:(NSArray *)data index:(NSInteger)index {
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:data];
    browser.displayToolbar = NO;
    [browser setInitialPageIndex:index - 100];
    [self presentViewController:browser animated:YES completion:nil];
}

@end
