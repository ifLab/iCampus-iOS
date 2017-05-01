//
//  PJMapViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJMapViewController.h"
#import "PJMapView.h"
#import "ICNetworkManager.h"

@interface PJMapViewController ()

@end

@implementation PJMapViewController
{
    PJMapView *_kMapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = @"地图";
    self.view.backgroundColor = [UIColor whiteColor];
    _kMapView = [[PJMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_kMapView];
    
    [self getDataFromHttp];
}

- (void)getDataFromHttp {
    [[ICNetworkManager defaultManager] GET:@"Map"
                                parameters:nil
                                   success:^(NSDictionary *dic) {
                                       NSArray *data = dic[@"resource"];;
                                       _kMapView.dataArr = [data mutableCopy];
                                   }
                                   failure:^(NSError *error) {
                                       // error信息要怎么处理？
                                   }];
}

@end
