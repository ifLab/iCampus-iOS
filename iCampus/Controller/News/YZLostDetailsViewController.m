//
//  YZLostDetailsViewController.m
//  iCampus
//
//  Created by 戚译中 on 2017/9/30.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "YZLostDetailsViewController.h"
#import "YZLostDetailsView.h"
#import "IDMPhotoBrowser.h"

@interface YZLostDetailsViewController ()<YZLostDetailsViewDelegate>{
    YZLostDetailsView* _kYZLostDetailsView;
}

@end

@implementation YZLostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void) setupUI{
    _kYZLostDetailsView = [[YZLostDetailsView alloc]init];
    _kYZLostDetailsView.dataSource = _dataSource;
    _kYZLostDetailsView.LostDetailsViewDelegate = self;
    self.title = @"失误详情";
    [self.view addSubview:_kYZLostDetailsView];
    _PhoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _PhoneBtn.frame = CGRectMake(SCREEN_WIDTH-54, SCREEN_HEIGHT-54, 54, 54);
    [_PhoneBtn setBackgroundColor:RGB(24, 116, 205)];
    [_PhoneBtn addTarget:self action:@selector(pressPhoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_PhoneBtn];
    
    _ChatBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _ChatBtn.frame = CGRectMake(SCREEN_WIDTH-108, SCREEN_HEIGHT-54, 54, 54);
    [_ChatBtn setBackgroundColor:RGB(176, 226, 255)];
    [_ChatBtn addTarget:self action:@selector(pressChatBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ChatBtn];
    
    UIBarButtonItem* ShareBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pressShareBtn)];
    self.navigationItem.rightBarButtonItem = ShareBtn;
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
}

- (void) pressPhoneBtn{
    //按按钮打电话
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _dataSource[@"phone"]]]];
}

- (void) pressChatBtn{
    
}

- (void) pressShareBtn{
    
}

- (void) clickImage:(NSArray*)photos andTag:(NSInteger)tag{
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    browser.displayToolbar = NO;
    browser.displayDoneButton = NO;
    browser.dismissOnTouch = YES;
    [browser setInitialPageIndex:tag - 100];
    [self presentViewController:browser animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
