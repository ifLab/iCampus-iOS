
//
//  PJBusDetailsViewController.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJBusDetailsViewController.h"
#import "PJBusDetailsTableView.h"
#import "ICNetworkManager.h"

@interface PJBusDetailsViewController ()

@end

@implementation PJBusDetailsViewController {
    PJBusDetailsTableView *_kTableView;
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
    self.title = [NSString stringWithFormat:@"%@", _dataSource[@"busName"]];
    self.view.backgroundColor = [UIColor whiteColor];
    _kTableView = [PJBusDetailsTableView new];
    NSData *jsonData = [_dataSource[@"busLine"] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    _kTableView.dataArr = [self setupDataArr:dataArr];
    [self.view addSubview:_kTableView];
}

// 调整班车字典
- (NSMutableArray *)setupDataArr:(NSArray *)arr {
    int isRed = 0;
    NSMutableArray *dataArr = [@[] mutableCopy];
    // 取出回程时间字符串
    NSString *returnTimeStr = [NSString stringWithFormat:@"%@", _dataSource[@"returnTime"]];
    if (![returnTimeStr isEqualToString:@""]) {
        returnTimeStr = [returnTimeStr substringToIndex:5];
    }
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *dict = arr[i];
        if ([returnTimeStr isEqualToString:dict[@"arrivalTime"]]) {
            isRed = 1;
        }
        NSMutableDictionary *d = [dict mutableCopy];
        [d setValue:[NSString stringWithFormat:@"%d", isRed] forKey:@"isRed"];
        
        // 添加isTopLine和isBottomLine字段，用于判断tableView是否将其二者显示
        [d setValue:[NSString stringWithFormat:@"%d", 1] forKey:@"isTopLine"];
        [d setValue:[NSString stringWithFormat:@"%d", 1] forKey:@"isBottomLine"];
        if (i == 0) {
            [d setValue:[NSString stringWithFormat:@"%d", 0] forKey:@"isTopLine"];
            d[@"isTopLine"] = @"0";
        }
        if (i == arr.count - 1) {
            [d setValue:[NSString stringWithFormat:@"%d", 0] forKey:@"isBottomLine"];
            d[@"isBottomLine"] = @"0";
        }
        [dataArr addObject:d];
    }
    return dataArr;
}

@end
