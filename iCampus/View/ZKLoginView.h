//
//  ZKLoginView.h
//  iCampus
//
//  Created by 徐正科 on 2018/11/13.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKLoginViewDelegate <NSObject>

- (void)loginBtnActionWithUsername:(NSString *)username password:(NSString *)password;
- (void)registerBtnActionWithUsername:(NSString *)username passWord:(NSString *)password verifyCode:(NSString *)verifyCode;

@end


NS_ASSUME_NONNULL_BEGIN

@interface ZKLoginView : UIView

@property(nonatomic,weak) id<ZKLoginViewDelegate> delegate;

// 键盘弹出回收动画
- (void)keyboardChangeAnimationPushing:(BOOL)isPush;

// 取消TextField响应
- (void)resignAllFirstResponder;

@end

NS_ASSUME_NONNULL_END
