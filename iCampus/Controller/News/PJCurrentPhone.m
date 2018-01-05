//
//  PJCurrentPhone.m
//  iCampus
//
//  Created by pjpjpj on 2018/1/5.
//  Copyright © 2018年 ifLab. All rights reserved.
//

#import "PJCurrentPhone.h"

@implementation PJCurrentPhone

+ (BOOL)PJCurrentPhone:(NSString *)phoneType {

    if ([phoneType isEqualToString:@"iPhoneX"]) {
        return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
    }
    return false;
}

@end
