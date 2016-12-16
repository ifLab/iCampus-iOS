//
//  ICAppDelegate.h
//  iCampus
//
//  Created by Kwei Ma on 13-11-6.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "./External/GexinSdk/include/GexinSdk.h"

@class ICUser;

@interface ICAppDelegate : UIResponder <UIApplicationDelegate, GexinSdkDelegate> {
@private
//    UINavigationController *_naviController;
    NSString *_deviceToken;
}

- (void)setAliasWith:(NSString *)alias;
@property (strong, nonatomic) UIWindow *window;

@end
