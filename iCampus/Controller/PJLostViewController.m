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
#import "YZLostDetailsViewController.h"
#import "CASBistu.h"

@interface PJLostViewController () <PJLostTableViewDelegate,IDMPhotoBrowserDelegate>

@end

@implementation PJLostViewController {
    PJLostTableView *_kTableView;
    NSMutableArray *_freshData;
    int page;
    NSString *_freshFlag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self performSelector:@selector(CreatPublishBtn) withObject:nil afterDelay:0.5];
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
    _freshData = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"失物";
        
    _kTableView = [PJLostTableView new];
    [self.view addSubview:_kTableView];
    _kTableView.tableDelegate = self;
    _kTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headfresh)];
    _kTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footfresh)];
    
    if ([CASBistu checkCASCertified]) {
        [self getDataFromHttp];
        [_kTableView.mj_header beginRefreshing];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CASloginSuccess) name:@"UserDidLoginNotification" object:nil];
}

- (void)CASloginSuccess {
    [_kTableView.mj_header beginRefreshing];
}

- (void)CreatPublishBtn{
    _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishBtn setImage:[UIImage imageNamed:@"addLostFound"] forState:UIControlStateNormal];
    if (iPhoneX) {
        _publishBtn.frame = CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT - 140, 45, 45);
    } else {
        _publishBtn.frame = CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT - 110, 45, 45);
    }
    _publishBtn.layer.cornerRadius = 25;
    _publishBtn.layer.masksToBounds = false;
    _publishBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _publishBtn.layer.shadowOffset = CGSizeMake(2, 2);
    _publishBtn.layer.shadowOpacity = 0.3;
    _publishBtn.layer.shadowRadius = 2;
    [_publishBtn addTarget:self action:@selector(nextItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_publishBtn];
}

- (void)nextItemClick {
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJNewLost" bundle:nil];
    PJNewLostViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJNewLostViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getDataFromHttp {
    NSDictionary *paramters = @{@"offset":@(page*10),
                                @"filter":@"isFound=false"};
    [[ICNetworkManager defaultManager] GET:@"Lost"
                                parameters:paramters
                                   success:^(NSDictionary *dic) {
                                       [_kTableView.mj_header endRefreshing];
                                       [_kTableView.mj_footer endRefreshing];
                                       NSArray *data = dic[@"resource"];
                                       _freshData = (NSMutableArray*)[_freshData arrayByAddingObjectsFromArray:data];
                                       if (data.count) {
                                           if ([_freshFlag isEqualToString:headerRefresh]) {
                                               [_kTableView.dataArr removeAllObjects];
                                               _freshData = [data mutableCopy];
                                           }
                                           _kTableView.dataArr = [_freshData mutableCopy];
                                       } else {
                                           [PJHUD showErrorWithStatus:@"没有数据了"];
                                       }
                                      [_kTableView.mj_header endRefreshing];
                                   }
                                   failure:^(NSError *error) {
                                       [_kTableView.mj_header endRefreshing];
                                       NSLog(@"error:%@",error);
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
    browser.delegate = self;
    browser.displayToolbar = NO;
    browser.displayDoneButton = NO;
    browser.dismissOnTouch = YES;
    [browser setInitialPageIndex:index - 100];
    [self presentViewController:browser animated:YES completion:nil];
}

- (void)tableViewClickToDetails:(NSDictionary *)data{
    YZLostDetailsViewController* vc = [[YZLostDetailsViewController alloc]init];
    vc.dataSource = data;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return false;
}

@end
