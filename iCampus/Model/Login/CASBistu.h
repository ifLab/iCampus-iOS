//
//  CASBistu.h
//  iCampus
//
//  Created by Bill Hu on 2017/6/21.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CAS_iOS;
@import serverURL;

@interface CASBistu : NSObject

+ (void)loginWithUsername:(NSString *)user
                 password:(NSString *)pass
            callBackBlock:(void (^)(NSDictionary *, NSString *))callBackBlock;

+ (bool)checkCASCertified;

+ (bool)showCASController;

@end
