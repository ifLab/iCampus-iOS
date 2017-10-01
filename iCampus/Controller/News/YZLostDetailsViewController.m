//
//  YZLostDetailsViewController.m
//  iCampus
//
//  Created by 戚译中 on 2017/9/30.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "YZLostDetailsViewController.h"
#import "YZLostDetailsView.h"

@interface YZLostDetailsViewController (){
    YZLostDetailsView* _yzlostdetailsView;
}

@end

@implementation YZLostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* ReturnBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(pressReturnBtn)];
    self.navigationItem.leftBarButtonItem = ReturnBtn;
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void) setupUI{
    _yzlostdetailsView = [[YZLostDetailsView alloc]init];
    _yzlostdetailsView.dataSource = _dataSource;
    self.title = @"失误详情";
    [self.view addSubview:_yzlostdetailsView];
    _PhoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _PhoneBtn.frame = CGRectMake(SCREEN_WIDTH-54, SCREEN_HEIGHT-54, 54, 54);
    [_PhoneBtn setBackgroundColor:RGB(24, 116, 205)];
    [self.view addSubview:_PhoneBtn];
    
    _ChatBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _ChatBtn.frame = CGRectMake(SCREEN_WIDTH-108, SCREEN_HEIGHT-54, 54, 54);
    [_ChatBtn setBackgroundColor:RGB(176, 226, 255)];
    [self.view addSubview:_ChatBtn];
}

- (void) pressReturnBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
