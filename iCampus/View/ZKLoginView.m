//
//  ZKLoginView.m
//  iCampus
//
//  Created by 徐正科 on 2018/11/13.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import "ZKLoginView.h"


static const CGFloat kTabBtnHeight = 60;
static const CGFloat kTextFieldHeight = 60;
static const CGFloat kActionBtnWidth = 250;
static const CGFloat kActionBtnHeight = 50;
static const CGFloat kStateViewWidth = 30;


@interface ZKLoginView()

@property(nonatomic,weak)UIView *loginView;
@property(nonatomic,weak)UIView *registerView;

@property(nonatomic,weak)UIView *mainView;

// 登录注册状态切换按钮
@property(nonatomic,weak)UIButton *loginTabBtn;
@property(nonatomic,weak)UIButton *registerTabBtn;

// 登录功能输入框
@property(nonatomic,weak)UITextField *loginUsernameTextField;
@property(nonatomic,weak)UITextField *loginPasswordTextField;

// 注册功能输入框
@property(nonatomic,weak)UITextField *registerUsernameTextField;
@property(nonatomic,weak)UITextField *registerPasswordTextField;
@property(nonatomic,weak)UITextField *registerVerifycodeTextField;

// 登录注册响应按钮
@property(nonatomic,weak)UIButton *loginActionBtn;
@property(nonatomic,weak)UIButton *registerActionBtn;

@property(nonatomic,assign)BOOL isRegisterState;
@property(nonatomic,strong)UIImageView *stateView;


@end

@implementation ZKLoginView

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    
    return self;
}

- (void)initView {
    self.frame = [UIScreen mainScreen].bounds;
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userLoginImage"]];
    bgImgView.frame = [UIScreen mainScreen].bounds;
    [self addSubview:bgImgView];
    
    UIView *mainView = [self getMainView];
    [self addSubview:mainView];
    self.mainView = mainView;
    
    [mainView addSubview:self.stateView];
    
    UIView *mainBodyView = [[UIView alloc] initWithFrame:CGRectMake(0, kTabBtnHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mainBodyView.backgroundColor = UIColor.whiteColor;
    [mainView addSubview:mainBodyView];
    
    UIView *loginView = [self getLoginView];
    [mainBodyView addSubview:loginView];
    self.loginView = loginView;
    
    UIView *registerView = [self getRegisterView];
    registerView.alpha = 0;
    [mainBodyView addSubview:registerView];
    self.registerView = registerView;
    
    [mainView addSubview:mainBodyView];
    
}


- (UIView *)getMainView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.3, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    
    UIButton *loginTabBtn = [self getTabButtonWithX:0 andTitle:@"登录"];
    [loginTabBtn addTarget:self action:@selector(tabBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginTabBtn];
    self.loginTabBtn = loginTabBtn;
    
    UIButton *registerTabBtn = [self getTabButtonWithX:SCREEN_WIDTH * 0.5 andTitle:@"注册"];
    [registerTabBtn addTarget:self action:@selector(tabBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:registerTabBtn];
    self.registerTabBtn = registerTabBtn;
    
    return view;
}

- (UIView *)getLoginView {
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loginView.backgroundColor = UIColor.whiteColor;
    
    UITextField *usernameTextField = [self getTextFieldWithPlaceHolder:@"手机号" isPassword:NO];
    [loginView addSubview:usernameTextField];
    self.loginUsernameTextField = usernameTextField;

    [loginView addSubview:[self getLineWithY:usernameTextField.mj_y + usernameTextField.mj_h]];
    
    UITextField *passwordTextField = [self getTextFieldWithPlaceHolder:@"密码" isPassword:YES];
    passwordTextField.mj_y = usernameTextField.mj_y + kTextFieldHeight + 1;
    [loginView addSubview:passwordTextField];
    self.loginPasswordTextField = passwordTextField;
    
    [loginView addSubview:[self getLineWithY:passwordTextField.mj_y + usernameTextField.mj_h]];
    
    UIButton *loginActionBtn = [self getActionBtnWithTitle:@"登录"];
    loginActionBtn.mj_y = passwordTextField.mj_y + passwordTextField.mj_h + 20;
    [loginActionBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginActionBtn];
    self.loginActionBtn = loginActionBtn;
    
    return loginView;
}

- (UIView *)getRegisterView {
    UIView *registerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    registerView.backgroundColor = UIColor.whiteColor;
    
    UITextField *usernameTextField = [self getTextFieldWithPlaceHolder:@"手机号" isPassword:NO];
    [registerView addSubview:usernameTextField];
    self.registerUsernameTextField = usernameTextField;
    
    [registerView addSubview:[self getLineWithY:usernameTextField.mj_y + usernameTextField.mj_h]];
    
    UITextField *verifyCodeTextField = [self getTextFieldWithPlaceHolder:@"验证码" isPassword:NO];
    verifyCodeTextField.mj_y = usernameTextField.mj_y + kTextFieldHeight + 1;
    [registerView addSubview:verifyCodeTextField];
    self.registerVerifycodeTextField = verifyCodeTextField;
    
    // 发送验证码
    UIButton *sendVerifyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendVerifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    sendVerifyBtn.frame = CGRectMake(registerView.mj_w - sendVerifyBtn.mj_w - verifyCodeTextField.mj_w * 0.5, verifyCodeTextField.mj_y, verifyCodeTextField.mj_w * 0.5, verifyCodeTextField.mj_h);
    [sendVerifyBtn addTarget:self action:@selector(sendVerifyAction) forControlEvents:UIControlEventTouchUpInside];
    [registerView addSubview:sendVerifyBtn];
    
    [registerView addSubview:[self getLineWithY:verifyCodeTextField.mj_y + verifyCodeTextField.mj_h]];

    UITextField *passwordTextField = [self getTextFieldWithPlaceHolder:@"密码" isPassword:YES];
    passwordTextField.mj_y = verifyCodeTextField.mj_y + kTextFieldHeight + 1;
    [registerView addSubview:passwordTextField];
    self.registerPasswordTextField = passwordTextField;
    
    [registerView addSubview:[self getLineWithY:passwordTextField.mj_y + usernameTextField.mj_h]];
    
    UIButton *loginActionBtn = [self getActionBtnWithTitle:@"注册"];
    loginActionBtn.mj_y = passwordTextField.mj_y + passwordTextField.mj_h + 20;
    [loginActionBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [registerView addSubview:loginActionBtn];
    self.registerActionBtn = loginActionBtn;
    
    return registerView;
}

/**
 * 获取输入框
 */

- (UITextField *)getTextFieldWithPlaceHolder:(NSString *)placeholder isPassword:(BOOL)isPwd {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0 , SCREEN_WIDTH - 60, kTextFieldHeight)];
    textField.placeholder = placeholder;
    textField.secureTextEntry = isPwd;
    
    return textField;
}

/**
 * 获取响应按钮
 */

- (UIButton *)getActionBtnWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, kActionBtnWidth, kActionBtnHeight);
    CGPoint center = btn.center;
    center.x = SCREEN_WIDTH * 0.5;
    btn.center = center;
    
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setBackgroundColor:UIColor.blackColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btn.mj_h * 0.5;
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}

/**
 * 获取三角形指示View
 */
- (UIImageView *)stateView {
    if (!_stateView) {
        _stateView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.25 - kStateViewWidth * 0.5, kTabBtnHeight - kStateViewWidth * 0.5, kStateViewWidth, kStateViewWidth)];
        _stateView.image = [UIImage imageNamed:@"三角"];
    }
    
    return _stateView;
}

/**
 * 登录按钮响应
 */
- (void)loginBtnAction {
    if([self.delegate respondsToSelector:@selector(loginBtnActionWithUsername:password:)]) {
        [self.delegate loginBtnActionWithUsername:self.loginUsernameTextField.text password:self.loginPasswordTextField.text];
    }
}

/**
 * 注册按钮响应
 */
- (void)registerBtnAction {
    if([self.delegate respondsToSelector:@selector(registerBtnActionWithUsername:passWord:verifyCode:)]) {
        [self.delegate registerBtnActionWithUsername:self.registerUsernameTextField.text passWord:self.registerPasswordTextField.text verifyCode:self.registerVerifycodeTextField.text];
    }
}

/**
 * 发送验证码
 */
- (void)sendVerifyAction {
    
}

- (UIButton *)getTabButtonWithX:(CGFloat)x andTitle:(NSString *)str {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x, 0, SCREEN_WIDTH * 0.5, kTabBtnHeight);
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    return btn;
}

/**
 * 分割线
 */
- (UIView *)getLineWithY:(CGFloat)y {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30, y, SCREEN_WIDTH - 30 * 2, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
    
    return lineView;
}

/**
 * 切换状态
 */

- (void)tabBtnAction:(UIButton *)btn {
    if (btn == self.loginTabBtn) {
        self.isRegisterState = NO;
    }else{
        self.isRegisterState = YES;
    }
    
    NSLog(@"%d",self.isRegisterState);
    [self changeState];
}

/**
 * 切换动画效果
 */
- (void)changeState {
    if (self.isRegisterState) {
        // 切换至注册模式
        [UIView animateWithDuration:0.25 animations:^{
            self.stateView.mj_x = SCREEN_WIDTH * 0.75 - kStateViewWidth * 0.5;
            
            self.loginView.alpha = 0;

        } completion:^(BOOL finished) {
            self.registerView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.stateView.mj_x = SCREEN_WIDTH * 0.25 - kStateViewWidth * 0.5;
            
            self.registerView.alpha = 0;

        } completion:^(BOOL finished) {
            self.loginView.alpha = 1;
        }];
    }
}

/**
 * 键盘弹出动画
 */

- (void)keyboardChangeAnimationPushing:(BOOL)isPush {
    // isPush == true 则上移，否则下移
    CGFloat moveY = 0;
    if (isPush) {
        moveY = 60;
    }else{
        moveY = SCREEN_HEIGHT * 0.3;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.mj_y = moveY;
    }];
}

/**
 * 取消所有响应实践
 */
- (void)resignAllFirstResponder {
    [self.loginPasswordTextField resignFirstResponder];
    [self.loginPasswordTextField resignFirstResponder];
    
    [self.registerUsernameTextField resignFirstResponder];
    [self.registerPasswordTextField resignFirstResponder];
    [self.registerVerifycodeTextField resignFirstResponder];
}
@end
