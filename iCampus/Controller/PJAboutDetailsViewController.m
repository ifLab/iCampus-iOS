//
//  PJAboutDetailsViewController.m
//  iCampus
//
//  Created by #incloud on 2017/4/30.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJAboutDetailsViewController.h"

@interface PJAboutDetailsViewController ()

@end

@implementation PJAboutDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = _dataSource[@"aboutName"];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
