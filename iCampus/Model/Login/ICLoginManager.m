 //
//  ICLoginManager.m
//  iCampus
//
//  Created by Bill Hu on 16/10/29.
//  Copyright © 2016年 BISTU. All rights reserved.
//

#import "ICLoginManager.h"
#import "ICNetworkManager.h"
#import <SMS_SDK/SMSSDK.h>
#import "iCampus-Swift.h"

@implementation ICLoginManager

+(void)login:(NSString *)email
    password:(NSString *)password
     success:(void (^)(NSDictionary *))success
     failure:(void (^)(NSString *))failure
{
    [[ICNetworkManager defaultManager] POST:@"Login"
                              GETParameters:nil
                             POSTParameters:@{
                                              @"email": email,
                                              @"password": password
                                              }
                                    success:^(NSDictionary *data) {
                                        NSString *session = data[@"session_token"];
                                        [ICNetworkManager defaultManager].token = session;
                                        PJUser *user = [PJUser new];
                                        user.name = data[@"name"];
                                        user.last_login_date = data[@"last_login_date"];
                                        [user save];
                                        success(data);
                                    }
                                    failure:^(NSError *error) {
                                        failure(error.userInfo[NSLocalizedDescriptionKey]);
                                    }];
}

+(void)fetchVerfyCode:(NSString *)phone
              success:(void (^)())success
              failure:(void (^)(NSString *))failure
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:phone zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                     if (error) {
                                         failure(error.userInfo[@"getVerificationCode"]);
                                     } else {
                                         success();
                                     }
                                 }];
}

+(void)signUp:(NSString *)email
     password:(NSString *)password
        phone:(NSString *)phone
    verfyCode:(NSString *)verfyCode
      success:(void (^)(NSDictionary *))success
      failure:(void (^)(NSString *))failure
{
    [SMSSDK commitVerificationCode:verfyCode
                       phoneNumber:phone
                              zone:@"86"
                            result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                                if (error) {
                                    failure(error.userInfo[@"commitVerificationCode"]);
                                } else {
                                    [[ICNetworkManager defaultManager] POST:@"Register"
                                                              GETParameters:nil
                                                             POSTParameters:@{
                                                                              @"email": email,
                                                                              @"password": password,
                                                                              @"phone": phone
                                                                              }
                                                                    success:^(NSDictionary *data) {
                                                                        success(data);
                                                                    }
                                                                    failure:^(NSError *error) {
                                                                        failure(error.userInfo[NSLocalizedDescriptionKey]);
                                                                    }];
                                }
                            }];
}

+(void)resetPassword:(NSString *)email
             success:(void (^)(NSString *))success
             failure:(void (^)(NSString *))failure
{
    [[ICNetworkManager defaultManager] POST:@"Change Password"
                              GETParameters:@{
                                              @"reset":@"true"
                                              }
                             POSTParameters:@{
                                              @"email": email
                                              }
                                    success:^(NSDictionary *data) {
                                        success(@"success");
                                    }
                                    failure:^(NSError *error) {
                                        failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                    }];
}

+(void)refreshTokenWith:(void (^)(NSString *))failure
{
    [[ICNetworkManager defaultManager] PUT:@"Login" parameters:nil success:^(NSDictionary *data) {
        NSString *session = data[@"session_token"];
        [ICNetworkManager defaultManager].token = session;
    } failure:^(NSError *error) {
        failure(error.userInfo[NSLocalizedDescriptionKey]);
    }];
}

-(void)saveUserInfo:(NSDictionary *)result{
   
}

@end
