//
//  ZKLoginViewController.m
//  iCampus
//
//  Created by 徐正科 on 2018/11/13.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import "ZKLoginViewController.h"
#import "ZKLoginView.h"
#import "ICLoginManager.h"
#import "UserModel.h"

@interface ZKLoginViewController()<ZKLoginViewDelegate>

@property(nonatomic,weak)ZKLoginView *mainView;

@end

@implementation ZKLoginViewController

- (void)viewDidLoad {
    ZKLoginView *loginView = [ZKLoginView new];
    [self.view addSubview:loginView];
    self.mainView = loginView;
    self.mainView.delegate = self;
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidShowNotification object:nil];
    
    // 监听键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasChange:(NSNotification *)notification {
    if (notification.name == UIKeyboardDidShowNotification) {
        // 键盘弹出
        [self.mainView keyboardChangeAnimationPushing:YES];
    }else{
        // 键盘消失
        [self.mainView keyboardChangeAnimationPushing:NO];
    }
}

- (void)loginBtnActionWithUsername:(NSString *)username password:(NSString *)password {
    [self.mainView resignAllFirstResponder];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    interval = (interval / 300) + 1;
    
    password = [NSString stringWithFormat:@"%@%.0lf",password.md5,interval];
    password = password.md5;
    
    if (username.length != 11) {
        [PJHUD showErrorWithStatus:@"请输入正确手机号"];
        return ;
    }
    
    if (password.length == 0) {
        [PJHUD showErrorWithStatus:@"请输入密码"];
        return ;
    }
    
    [SVProgressHUD show];
    [ICLoginManager login:username password:password timestamp:[NSString stringWithFormat:@"%.0lf",interval] success:^(NSDictionary *data) {
        if ([data[kMsgCode] integerValue] == ICNetworkResponseCodeSuccess) {
            // 登录成功
            UserModel *user = [UserModel mj_objectWithKeyValues:data[kMsg]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationKey object:self userInfo:nil];
            
            [user loginSuccess];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [PJHUD showErrorWithStatus:data[kMsg]];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
    }];
    
}

- (void)registerBtnActionWithUsername:(NSString *)username passWord:(NSString *)password verifyCode:(NSString *)verifyCode {
    [self.mainView resignAllFirstResponder];
    
    if (username.length != 11) {
        [PJHUD showErrorWithStatus:@"请输入正确手机号"];
        return ;
    }
    
    if (password.length == 0) {
        [PJHUD showErrorWithStatus:@"请输入密码"];
        return ;
    }
    
    if (verifyCode.length == 0) {
        [PJHUD showErrorWithStatus:@"请输入验证码"];
        return ;
    }
    
    [PJHUD showWithStatus:@""];
    [ICLoginManager signUp:nil password:password.md5 phone:username verfyCode:verifyCode success:^(NSDictionary *dict) {
        [PJHUD dismiss];
        if ([dict[kMsgCode] integerValue] == ICNetworkResponseCodeSuccess) {
            [PJHUD showWithStatus:@"注册成功"];
        }else{
            [PJHUD showErrorWithStatus:dict[kMsg]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [PJHUD dismiss];
        });
        
        
    } failure:^(NSString *err){
        NSLog(@"注册失败: %@",err);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.mainView resignAllFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
