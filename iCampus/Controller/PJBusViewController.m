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

@interface PJBusViewController () <PJBusTableViewDelegate, UIViewControllerPreviewingDelegate>

@end

@implementation PJBusViewController {
    PJBusTableView *_kTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [PJHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"校车"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"校车"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = @"校车";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    _kTableView = [PJBusTableView new];
    _kTableView.tableDelegate = self;
    [self.view addSubview:_kTableView];
    
    [self getDataFromHttp];
    
    //隐藏下一层的TabBar
    self.hidesBottomBarWhenPushed = YES;
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

- (void)PJRegister3DtouchCell:(PJBusTableViewCell *)cell {
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:(UIView *)cell];
    }
}

//peek
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [_kTableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    PJBusDetailsViewController *vc = [PJBusDetailsViewController new];
    vc.dataSource = _kTableView.dataArr[indexPath.row];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,60);
    previewingContext.sourceRect = rect;
    return vc;
}

//pop
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

@end
