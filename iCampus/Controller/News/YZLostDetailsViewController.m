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
#import <UShareUI/UShareUI.h>

@interface YZLostDetailsViewController ()<YZLostDetailsViewDelegate>{
    YZLostDetailsView* _kYZLostDetailsView;
}

@end

@implementation YZLostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void) setupUI{
    _kYZLostDetailsView = [[YZLostDetailsView alloc]init];
    _kYZLostDetailsView.dataSource = _dataSource;
    _kYZLostDetailsView.LostDetailsViewDelegate = self;
    self.title = @"失物详情";
    [self.view addSubview:_kYZLostDetailsView];
        
    NSMutableArray *buttons=[[NSMutableArray alloc] initWithCapacity:5];
    UIBarButtonItem *ShareBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"newsShare"] style:UIBarButtonItemStyleDone target:self action:@selector(pressShareBtn)];
    UIBarButtonItem *messageBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message"] style:UIBarButtonItemStyleDone target:self action:@selector(pressChatBtn)];
    UIBarButtonItem *phoneBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"phone"] style:UIBarButtonItemStyleDone target:self action:@selector(pressPhoneBtn)];
    [buttons addObjectsFromArray:@[ShareBtn, messageBtn, phoneBtn]];

    self.navigationItem.rightBarButtonItems = buttons;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
}

- (void) pressPhoneBtn{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _dataSource[@"phone"]]] options:@{} completionHandler:^(BOOL success) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:date];
        NSDictionary *dict = @{
                               @"username":[PJUser currentUser].first_name,
                               @"uploadtime":dateString
                               };
        [MobClick event:@"ibistu_lost_details_phone" attributes:dict];
    }];
}

- (void) pressChatBtn{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", _dataSource[@"phone"]]] options:@{} completionHandler:^(BOOL success) {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
            NSString *dateString = [formatter stringFromDate:date];
            NSDictionary *dict = @{
                                   @"username":[PJUser currentUser].first_name,
                                   @"time":dateString
                                   };
            [MobClick event:@"ibistu_lost_details_message" attributes:dict];
    }];
}

- (void) pressShareBtn{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareImageToPlatformType:platformType];
    }];
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:[_kYZLostDetailsView shareImage]];
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
        }else{
//            NSLog(@"response data is %@",data);
        }
    }];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSDictionary *dict = @{
                           @"username":[PJUser currentUser].first_name,
                           @"uploadtime":dateString
                           };
    [MobClick event:@"ibistu_lost_details_share" attributes:dict];
}

- (void)clickImage:(NSArray*)photos andTag:(NSInteger)tag{
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
