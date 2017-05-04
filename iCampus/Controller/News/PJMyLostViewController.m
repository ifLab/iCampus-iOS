//
//  PJMyLostViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/3.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJMyLostViewController.h"
#import "PJMyPublishLostTableView.h"


@interface PJMyLostViewController ()

@end

@implementation PJMyLostViewController
{
    PJMyPublishLostTableView *_kTableView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布的失物招领";
    
    _kTableView = [PJMyPublishLostTableView new];
    [self.view addSubview:_kTableView];
}

@end
