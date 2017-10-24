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
#import "OXExpandingButtonBar.h"

@interface YZLostDetailsViewController ()<YZLostDetailsViewDelegate>{
    YZLostDetailsView* _kYZLostDetailsView;
    OXExpandingButtonBar *_bar;
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
    
    [self CreatMainBtn];
    
    UIBarButtonItem *ShareBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share1"] style:UIBarButtonItemStyleDone target:self action:@selector(pressShareBtn)];
    self.navigationItem.rightBarButtonItem = ShareBtn;
}

- (void)CreatMainBtn{
    UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mainBtn.frame = CGRectMake(0, 0, 50, 50);
    [mainBtn setBackgroundImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
    mainBtn.transform = CGAffineTransformMakeRotation(0);
    mainBtn.alpha = 0.7;
    
    _PhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_PhoneBtn setImage:[UIImage imageNamed:@"phoneBtn"] forState:UIControlStateNormal];
    _PhoneBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _PhoneBtn.frame = CGRectMake(0, 0, 50, 50);
    [_PhoneBtn addTarget:self action:@selector(pressPhoneBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _ChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ChatBtn.frame = CGRectMake(0, 0, 50, 50);
    [_ChatBtn setImage:[UIImage imageNamed:@"chatBtn"] forState:UIControlStateNormal];
    _ChatBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_ChatBtn addTarget:self action:@selector(pressChatBtn) forControlEvents:UIControlEventTouchUpInside];

    NSArray *buttons = [NSArray arrayWithObjects:_PhoneBtn,_ChatBtn, nil];
    _bar = [[OXExpandingButtonBar alloc] initWithMainButton:mainBtn buttons:buttons center:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT-130)];
    [_bar setMainRotate:-M_PI];
    [_bar setMainReRotate:0];
    [_bar setAnimated:YES];
    [self.view addSubview:_bar];
    
    [UIView animateWithDuration:0.5f animations:^{
        _bar.center = CGPointMake(SCREEN_WIDTH-40, SCREEN_HEIGHT-130);
    }];
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

- (void)viewWillDisappear:(BOOL)animated{
    _returnblock();
}
@end
