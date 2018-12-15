//
//  YZLostDetailsViewController.m
//  iCampus
//
//  Created by 戚译中 on 2017/9/30.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "YZLostDetailsViewController.h"
#import "YZLostDetailsView.h"
#import "BlogDetailView.h"
#import "IDMPhotoBrowser.h"
#import <UShareUI/UShareUI.h>
#import "BlogModel.h"
#import "CommentModel.h"
#import <XHInputView/XHInputView.h>

@interface YZLostDetailsViewController ()<YZLostDetailsViewDelegate, XHInputViewDelagete>{
    BlogDetailView* _kYZLostDetailsView;
}

@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSMutableArray<CommentModel *> *comments;

@end

@implementation YZLostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    self.comments = [@[] mutableCopy];
    
    [CommentModel getCommentsWithBlogID:_dataSource.blog_id page:_page success:^(NSArray<CommentModel *> * _Nonnull data) {
        [self.comments addObjectsFromArray:data];
        _kYZLostDetailsView.comments = self.comments;
    } failure:^(NSString * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取评论失败"];
    }];
}

- (void) setupUI{
    _kYZLostDetailsView = [[BlogDetailView alloc]init];
    _kYZLostDetailsView.dataSource = _dataSource;
//    _kYZLostDetailsView.LostDetailsViewDelegate = self;
    self.title = @"帖子详情";
    [self.view addSubview:_kYZLostDetailsView];
    
//    NSMutableArray *buttons=[[NSMutableArray alloc] initWithCapacity:5];
//    UIBarButtonItem *ShareBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"newsShare"] style:UIBarButtonItemStyleDone target:self action:@selector(pressShareBtn)];
//    UIBarButtonItem *messageBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message"] style:UIBarButtonItemStyleDone target:self action:@selector(pressChatBtn)];
//    UIBarButtonItem *phoneBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"phone"] style:UIBarButtonItemStyleDone target:self action:@selector(pressPhoneBtn)];
//    [buttons addObjectsFromArray:@[ShareBtn, messageBtn, phoneBtn]];

    UIBarButtonItem *commentBtn = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(pressCommentBtn)];
    self.navigationItem.rightBarButtonItem = commentBtn;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}

- (void)setDataSource:(BlogModel *)dataSource{
    _dataSource = dataSource;
}

- (void)pressCommentBtn {
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 代理 */
        inputView.delegate = self;
        
        /** 占位符文字 */
        inputView.placeholder = @"请输入评论文字...";
        /** 设置最大输入字数 */
        inputView.maxCount = 250;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
    } sendBlock:^BOOL(NSString *text) {
        [SVProgressHUD show];
        if(text.length){
            [CommentModel commentWithContentType:kCommentTypeBlog contentID:_dataSource.blog_id content:text parentID:0 success:^(NSString * _Nonnull msg) {
                [SVProgressHUD showSuccessWithStatus:msg];
            } failure:^(NSString * _Nonnull err) {
                [SVProgressHUD showErrorWithStatus:err];
            }];
            
            return YES;
        }else{
            return YES;//return NO,不收键盘
        }
    }];
}

- (void) pressPhoneBtn{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _dataSource[@"phone"]]] options:@{} completionHandler:^(BOOL success) {
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
//        NSString *dateString = [formatter stringFromDate:date];
//        NSDictionary *dict = @{
//                               @"username":[PJUser currentUser].first_name,
//                               @"uploadtime":dateString
//                               };
//        [MobClick event:@"ibistu_lost_details_phone" attributes:dict];
//    }];
}

- (void) pressChatBtn{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", _dataSource[@"phone"]]] options:@{} completionHandler:^(BOOL success) {
//            NSDate *date = [NSDate date];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
//            NSString *dateString = [formatter stringFromDate:date];
//            NSDictionary *dict = @{
//                                   @"username":[PJUser currentUser].first_name,
//                                   @"time":dateString
//                                   };
//            [MobClick event:@"ibistu_lost_details_message" attributes:dict];
//    }];
}

- (void) pressShareBtn{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareImageToPlatformType:platformType];
    }];
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType{
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    [shareObject setShareImage:[_kYZLostDetailsView shareImage]];
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
//        if (error) {
////            NSLog(@"************Share fail with error %@*********",error);
//        }else{
////            NSLog(@"response data is %@",data);
//        }
//    }];
//    
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
//    NSString *dateString = [formatter stringFromDate:date];
//    NSDictionary *dict = @{
//                           @"username":[PJUser currentUser].first_name,
//                           @"uploadtime":dateString
//                           };
//    [MobClick event:@"ibistu_lost_details_share" attributes:dict];
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

/** XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView
{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要显示时将其关闭 */
    
    //[IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //[IQKeyboardManager sharedManager].enable = NO;
    
}

/** XHInputView 将要影藏 */
-(void)xhInputViewWillHide:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要影藏时将其打开 */
    
    //[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    //[IQKeyboardManager sharedManager].enable = YES;
}

@end
