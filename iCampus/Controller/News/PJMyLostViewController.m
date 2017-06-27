//
//  PJMyLostViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/3.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJMyLostViewController.h"
#import "PJMyPublishLostTableView.h"
#import "ICNetworkManager.h"
#import "IDMPhotoBrowser.h"


@interface PJMyLostViewController () <PJMyPublishLostTableViewDelegate>

@end

@implementation PJMyLostViewController
{
    PJMyPublishLostTableView *_kTableView;
    
    int page;
    NSString *_freshFlag;
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
    page = 0;
    _freshFlag = headerRefresh;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布的失物招领";
    
    _kTableView = [PJMyPublishLostTableView new];
    _kTableView.tableDelegate = self;
    _kTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headfresh)];
    _kTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footfresh)];
    [self.view addSubview:_kTableView];
    
    [self getDataFromHttp];
}

- (void)getDataFromHttp {
    NSString *filterStr = [NSString stringWithFormat:@"(isFound=false)And(author=%@)", [PJUser currentUser].name];
    NSDictionary *paramters = @{@"offset":@(page*10),
                                @"filter":filterStr};
    [PJHUD showWithStatus:@""];
    [[ICNetworkManager defaultManager] GET:@"Lost"
                                parameters:paramters
                                   success:^(NSDictionary *dic) {
                                       [_kTableView.mj_header endRefreshing];
                                       [_kTableView.mj_footer endRefreshing];
                                       
                                       [PJHUD dismiss];
                                       NSArray *data = dic[@"resource"];
                                       if (data.count) {
                                           if ([_freshFlag isEqualToString:headerRefresh]) {
                                               [_kTableView.tableDataArr removeAllObjects];
                                           }
                                           _kTableView.tableDataArr = [data mutableCopy];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除失物" message:@"是否找到失物主人？" preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self updateLost:indexPath.row];
        _kTableView.editing = NO;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"没有" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        _kTableView.editing = NO;
    }]];
    [self presentViewController:alert animated:true completion:nil];

}

- (void)updateLost:(NSInteger)index {
    NSString *webSite = [NSString stringWithFormat:@"https://api.iflab.org/api/v2/ibistu/_table/module_lost_found/%d?", (int)[_kTableView.tableDataArr[index][@"id"] integerValue]];
    [[ICNetworkManager defaultManager] PATCHWithWebSite:webSite
                                          GETParameters:nil
                                         POSTParameters:@{@"isFound": @1}
                                                success:^(NSDictionary *dict) {
                                                    [PJHUD showSuccessWithStatus:@"删除成功"];
                                                    [_kTableView.tableDataArr removeObjectAtIndex:index];
                                                    [_kTableView reloadData];
                                                } failure:^(NSError *error) {
                                                    NSLog(@"failure");
                                                }];
}

- (void)tableViewClick:(NSArray *)data index:(NSInteger)index {
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:data];
    browser.displayToolbar = NO;
    [browser setInitialPageIndex:index - 100];
    [self presentViewController:browser animated:YES completion:nil];
}
@end
