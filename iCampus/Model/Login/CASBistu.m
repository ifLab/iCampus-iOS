//
//  CASBistu.m
//  iCampus
//
//  Created by Bill Hu on 2017/6/21.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "CASBistu.h"
#import "ICLoginManager.h"
#import "UserModel.h"

@implementation CASBistu

+ (void)loginWithUsername:(NSString *)user
                 password:(NSString *)pass
            callBackBlock:(void (^)(NSDictionary *, NSString *))callBackBlock {
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
                            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:0
                                                                                   error:&error];
                            if (info) {
                                [UserModel updateUserInfo:@{ @"nick_name": info[@"xm"]} success:^{
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setValue:@(YES) forKey:kLoginCASCertifiedSuccessKey];
                                    [NSNotificationCenter.defaultCenter postNotificationName:kLoginCASCertifiedSuccessNotificationKey object:self userInfo:nil];
                                    
                                    [SVProgressHUD showWithStatus:@"已通过CAS认证"];
                                    
                                    if (callBackBlock) {
                                        callBackBlock(info, nil);
                                    }
                                        
                                } fialure:^(NSString * _Nonnull error) {
                                    [SVProgressHUD showErrorWithStatus:@"未通过CAS认证，部分功能无法使用"];
                                }];
//                                [ICLoginManager editInfoWithfirst_name:info[@"xm"]
//                                                             last_name:@"@"
//                                                               success:^(NSDictionary *_) {
//                                                                   PJUser *user = [PJUser currentUser];
//                                                                   user.first_name = info[@"xm"];
//                                                                   user.last_name = @"@";
//                                                                   [user save];
//                                                                   if (callBackBlock) {
//                                                                       callBackBlock(info, nil);
//                                                                   }
//                                                               }
//                                                               failure:^(NSString *message) {
//                                                                   callBackBlock(@{}, message);
//                                                               }];
                            } else {
                                NSLog(@"%@", error);
                                if (callBackBlock) {
                                    callBackBlock(@{}, error.userInfo[@"NSLocalizedDescription"]);
                                }
                            }
                        } else {
                            NSLog(@"%@", error);
                            if (callBackBlock) {
                                callBackBlock(@{}, error.userInfo[@"NSLocalizedDescription"]);
                            }
                        }
                    }];
                } else {
                    NSLog(@"%@", error);
                    if (callBackBlock) {
                        callBackBlock(@{}, error.userInfo[@"NSLocalizedDescription"]);
                    }
                }
            }];
        } else {
            NSLog(@"%@", error);
            if (callBackBlock) {
                callBackBlock(@{}, error.userInfo[@"NSLocalizedDescription"]);
            }
        }
    }];
}

+ (bool)checkCASCertified {
    return UserModel.CASCertified;
}

# pragma warning ZK-CAS的二层验证,暂时关闭
+ (bool)showCASController {

//    if ([@"not_show" isEqualToString:[HBServerURL getWithAppNameAndURL:@"https://api.iflab.org/api/v2/serverurl/_table/serverurl/" apikey:@"c4c6a2a605c559a089f785394561919eecf2c548b631f3256678870f07691b50"]]) {
//        return false;
//    } else {
//        return true;
//    }
    
    return YES;
}

@end
