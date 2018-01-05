#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define WS(weakSelf) __weak typeof(self) weakSelf = self
#define RGB(r,g,b)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define GetAppDelegate (AppDelegate*)([UIApplication sharedApplication].delegate)
#define headerRefresh @"header"
#define footerRefresh @"footer"

#ifndef iPhoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#endif


extern UIColor * mainRedColor;
extern UIColor * mainBlackColor;
extern UIColor * mainPurpleColor;
extern UIColor * mainDeepSkyBlue;
extern UIColor * mainGreen;
extern UIColor * mainBlue;
extern CGFloat normalTableHeight;
