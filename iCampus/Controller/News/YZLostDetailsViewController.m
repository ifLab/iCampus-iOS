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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", _dataSource[@"phone"]]]];
}

- (void) pressShareBtn{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareImageToPlatformType:platformType];
    }];
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType{
    UIImage *image = [self imageFromView:_kYZLostDetailsView.scrollview];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:image];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
        }else{
//            NSLog(@"response data is %@",data);
        }
    }];
}

- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext: context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
