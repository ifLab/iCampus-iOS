//
//  CASBistu.m
//  iCampus
//
//  Created by Bill Hu on 2017/6/21.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "CASBistu.h"

@implementation CASBistu

+ (void)loginWithUsername:(NSString *)user
                 password:(NSString *)pass
            callBackBlock:(void (^)(NSDictionary *, NSError *))callBackBlock {
    if (!callBackBlock) {
        return;
    }
    NSString *loginURL = @"https://cas.bistu.edu.cn/ibistu/login.php";
    [CAS defaultCAS].casServer = @"https://cas.bistu.edu.cn/v1";
    [CAS defaultCAS].path = @"tickets";
    [[CAS defaultCAS] requestTGTWithUsername:user password:pass callBackBlock:^(NSString * tgt, NSError * error) {
        if (!error) {
            
            [[CAS defaultCAS] requestSTForService:loginURL callBackBlock:^(NSString *st, NSError *error) {
                if (!error) {
                    
                    NSString *url = [NSString stringWithFormat:@"%@?ticket=%@", loginURL, st];
                    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                    [[CAS defaultCAS] sendrequestWithRequest:req callBackBlock:^(NSData *data, NSURLResponse *resp, NSError *error) {
                        if (!error) {
                            NSError *error;
                            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                            if (info) {
                                callBackBlock(info, error);
                            } else {
                                NSLog(@"%@", error);
                                callBackBlock(@{}, error);
                            }
                        } else {
                            NSLog(@"%@", error);
                            callBackBlock(@{}, error);
                        }
                    }];
                    
                } else {
                    NSLog(@"%@", error);
                    callBackBlock(@{}, error);
                }
            }];
            
        } else {
            NSLog(@"%@", error);
            callBackBlock(@{}, error);
        }
    }];
}

@end
