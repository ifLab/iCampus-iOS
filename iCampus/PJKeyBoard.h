#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PJKeyBoard;
@protocol PJKeyBoardDelegate <NSObject>

- (void)keyboardWillShowNotification:(NSNotification *)notification;
- (void)keyboardWillHideNotification:(NSNotification *)notification;

@end
@interface PJKeyBoard : NSObject
/**
 *  注册键盘出现
 *
 *  @param target 目标(self)
 */
+ (void)registerKeyBoardShow:(id)target;
/**
 *  注册键盘隐藏
 *
 *  @param target 目标(self)
 */
+ (void)registerKeyBoardHide:(id)target;
/**
 *
 *
 *  @return 返回键盘，包括高度、宽度
 */
+ (CGRect)returnKeyBoardWindow:(NSNotification *)notification;
/**
 *
 *
 *  @return 返回键盘上拉动画持续时间
 */
+ (double)returnKeyBoardDuration:(NSNotification *)notification;
/**
 *  
 *
 *  @return 返回键盘上拉，下拉动画曲线
 */
+ (UIViewAnimationCurve)returnKeyBoardAnimationCurve:(NSNotification *)notification;

@end
