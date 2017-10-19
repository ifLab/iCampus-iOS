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

@interface PJLostViewController () <PJLostTableViewDelegate,IDMPhotoBrowserDelegate>

@end

@implementation PJLostViewController
{
    PJLostTableView *_kTableView;
    NSMutableArray *_freshData;
    int page;
    NSString *_freshFlag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self performSelector:@selector(CreatPublishBtn) withObject:nil afterDelay:1];
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
    self.title = @"失物招领";
    
    UIBarButtonItem* backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    
    _kTableView = [PJLostTableView new];
    [self.view addSubview:_kTableView];
    _kTableView.tableDelegate = self;
    _kTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headfresh)];
    _kTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footfresh)];
    [self getDataFromHttp];
}

- (void)CreatPublishBtn{
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT-130, 50, 50)];
    _window.windowLevel = UIWindowLevelAlert + 1;
    _window.layer.cornerRadius = 12;
    _window.layer.masksToBounds = YES;
    _window.hidden = NO;
    
    _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishBtn setImage:[UIImage imageNamed:@"publish.png"] forState:UIControlStateNormal];
    _publishBtn.frame = CGRectMake(0, 0, 50, 50);
    [_publishBtn addTarget:self action:@selector(nextItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:_publishBtn];
    [_window makeKeyAndVisible];
    
    CGAffineTransform transform =CGAffineTransformRotate(_window.transform,M_PI);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    _window.frame = CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT-130, 50, 50);
    [_window setTransform:transform];
    [UIView setAnimationDuration:1.5];
    [UIView commitAnimations];
}

- (void)resignWindow{
    [_window resignKeyWindow];
    _window = nil;
}

- (void)nextItemClick {
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJNewLost" bundle:nil];
    PJNewLostViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJNewLostViewController"];
    vc.returnblock = ^{
        [self performSelector:@selector(CreatPublishBtn) withObject:nil afterDelay:0.5];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [self resignWindow];
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
                                       _freshData = (NSMutableArray*)[_freshData arrayByAddingObjectsFromArray:data];
                                       if (data.count) {
                                           if ([_freshFlag isEqualToString:headerRefresh]) {
                                               [_kTableView.dataArr removeAllObjects];
                                           }
                                           _kTableView.dataArr = [_freshData mutableCopy];
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
    browser.delegate = self;
    browser.displayToolbar = NO;
    browser.displayDoneButton = NO;
    browser.dismissOnTouch = YES;
    [browser setInitialPageIndex:index - 100];
    [self presentViewController:browser animated:YES completion:nil];
    [self resignWindow];
}

- (void)willDisappearPhotoBrowser:(IDMPhotoBrowser *)photoBrowser{
    [self performSelector:@selector(CreatPublishBtn) withObject:nil afterDelay:0.5];
}

- (void)tableViewClickToDetails:(NSDictionary *)data{
    YZLostDetailsViewController* vc = [[YZLostDetailsViewController alloc]init];
    vc.dataSource = data;
    vc.returnblock = ^{
        [self performSelector:@selector(CreatPublishBtn) withObject:nil afterDelay:0.5];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [self resignWindow];
}

@end
