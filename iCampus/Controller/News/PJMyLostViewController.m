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

@interface PJMyLostViewController () <PJMyPublishLostTableViewDelegate,IDMPhotoBrowserDelegate>

@end

@implementation PJMyLostViewController {
    PJMyPublishLostTableView *_kTableView;
    NSMutableArray *_freshData;
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
    self.title = @"发布的失物";
    
    _kTableView = [PJMyPublishLostTableView new];
    _kTableView.tableDelegate = self;

    _kTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headfresh)];
    _kTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footfresh)];
    if (@available(iOS 11.0, *)) {
        _kTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (iPhoneX) {
            _kTableView.contentInset = UIEdgeInsetsMake(84, 0, 0, 0);
        } else {
            _kTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
        _kTableView.scrollIndicatorInsets = _kTableView.contentInset;
    }
    [self.view addSubview:_kTableView];
    
    [_kTableView.mj_header beginRefreshing];
    [self getDataFromHttp];
}

- (void)getDataFromHttp {
    NSString *filterStr = [NSString stringWithFormat:@"(isFound=false)And(author=%@)", [PJUser currentUser].first_name];
    NSDictionary *paramters = @{
                                @"offset":@(page*10),
                                @"filter":filterStr
                                };
    [[ICNetworkManager defaultManager] GET:@"Lost"
                                parameters:paramters
                                   success:^(NSDictionary *dic) {
                                       [_kTableView.mj_header endRefreshing];
                                       [_kTableView.mj_footer endRefreshing];
                                       
                                       NSArray *data = dic[@"resource"];
                                       _freshData = (NSMutableArray*)[_freshData arrayByAddingObjectsFromArray:data];
                                       if (data.count) {
                                           if ([_freshFlag isEqualToString:headerRefresh]) {
                                               [_kTableView.tableDataArr removeAllObjects];
                                               _freshData = [data mutableCopy];
                                           }
                                           _kTableView.tableDataArr = [_freshData mutableCopy];
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

- (void)trashClick:(NSIndexPath*)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除失物" message:@"确定找到失物的主人了嘛？TA现在一定很着急" preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self updateLost:indexPath.row];
        _kTableView.editing = NO;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
                                                    [PJTapic succee];
                                                } failure:^(NSError *error) {
                                                    [PJHUD showErrorWithStatus:@"删除失败"];
                                                    [PJTapic error];
                                                }];
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

- (NSArray *)PJMyPublishLostTableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *detailAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"已找到" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self trashClick:indexPath];
    }];
    detailAction.backgroundColor = RGB(0, 205, 0);
    
    return @[detailAction];
}

@end
