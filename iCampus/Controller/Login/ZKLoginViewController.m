//
//  ZKLoginViewController.m
//  iCampus
//
//  Created by 徐正科 on 2018/11/13.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import "ZKLoginViewController.h"
#import "ZKLoginView.h"
#import "ICNetworkManager.h"

@interface ZKLoginViewController()<ZKLoginViewDelegate>

@property(nonatomic,weak)ZKLoginView *mainView;

@end

@implementation ZKLoginViewController

- (void)viewDidLoad {
    ZKLoginView *loginView = [ZKLoginView new];
    [self.view addSubview:loginView];
    self.mainView = loginView;
    
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
    
}

- (void)registerBtnActionWithUsername:(NSString *)username passWord:(NSString *)password verifyCode:(NSString *)verifyCode {
    [PJHUD showWithStatus:@""];
    []
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
