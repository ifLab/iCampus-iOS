//
//  NSString+Category.m
//  iCampus
//
//  Created by 徐正科 on 2018/11/13.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Category)
    
- (NSString *)md5 {
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
    
}

@end
