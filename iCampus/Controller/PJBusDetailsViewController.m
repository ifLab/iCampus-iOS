
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

@implementation PJBusDetailsViewController
{
    PJBusDetailsTableView *_kTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
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
    for (NSDictionary *dict in arr) {
        // 如果回程时间字符串 == 某个地点的到达时间，说明以下地点全为回程点
        if ([returnTimeStr isEqualToString:dict[@"arrivalTime"]]) {
            isRed = 1;
        }
        NSMutableDictionary *d = [dict mutableCopy];
        [d setValue:[NSString stringWithFormat:@"%d", isRed] forKey:@"isRed"];
        [dataArr addObject:d];
    }
    return dataArr;
}



@end
