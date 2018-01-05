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
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.backgroundColor = [UIColor whiteColor];
    [webView loadHTMLString:_dataSource[@"aboutDetails"] baseURL:nil];
    [self.view addSubview:webView];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSDictionary *dict = @{
                           @"username" : [PJUser currentUser].first_name,
                           @"pagename" : self.title,
                           @"time" : dateString
                           };
    [MobClick event:@"ibistu_about" attributes:dict];
}


@end
