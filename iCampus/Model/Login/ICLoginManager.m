//
//  ICLoginManager.m
//  iCampus
//
//  Created by Bill Hu on 16/10/29.
//  Copyright © 2016年 BISTU. All rights reserved.
//

#import <SMS_SDK/SMSSDK.h>

#import "ICLoginManager.h"
#import "ICNetworkManager.h"
#import "iCampus-Swift.h"

@implementation ICLoginManager

+(void)login:(NSString *)phoneNumber
    password:(NSString *)password
     success:(void (^)(NSDictionary *))success
     failure:(void (^)(NSString *))failure {
    [[ICNetworkManager defaultManager] POST:@"masuser/createmasuser"
                              GETParameters:nil
                             POSTParameters:@{
                                              @"phoneNumber": phoneNumber,
                                              @"password": password
                                              }
                                    success:^(NSDictionary *data) {
                                    
                                        NSLog(@"%@",data);
                                        
                                        
                                        NSString *session = data[@"session_token"];
                                        [ICNetworkManager defaultManager].token = session;
                                        PJUser *user = [PJUser new];
                                        user.name = data[@"name"];
                                        user.first_name = data[@"first_name"];
                                        user.last_name = data[@"last_name"];
                                        user.last_login_date = data[@"last_login_date"];
                                        user.email = data[@"email"];
                                        [user save];
                                        success(data);
                                    }
                                    failure:^(NSError *error) {
                                        failure(error.userInfo[NSLocalizedDescriptionKey]);
                                    }];
}

+(void)fetchVerfyCode:(NSString *)phone
              success:(void (^)())success
              failure:(void (^)(NSString *))failure {
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
      failure:(void (^)(NSString *))failure {
    
#warning 临时关闭短信验证码验证
//    [SMSSDK commitVerificationCode:verfyCode
//                       phoneNumber:phone
//                              zone:@"86"
//                            result:^(SMSSDKUserInfo *userInfo, NSError *error) {
//                                if (error) {
//                                    failure(error.userInfo[@"commitVerificationCode"]);
//                                } else {
//                                    [[ICNetworkManager defaultManager] POST:@"Register"
//                                                              GETParameters:nil
//                                                             POSTParameters:@{
//                                                                              @"email": email,
//                                                                              @"password": password,
//                                                                              @"phone": phone
//                                                                              }
//                                                                    success:^(NSDictionary *data) {
//                                                                        success(data);
//                                                                    } failure:^(NSError *error) {                                                                 failure(error.userInfo[NSLocalizedDescriptionKey]);
//                                                                    }];
//                                }
//                            }];
    
# warning 不验证验证码
    [[ICNetworkManager defaultManager] POST:@"masuser/createmasuser"
                              GETParameters:nil
                             POSTParameters:@{
                                              @"phoneNumber": phone,
                                              @"password": password,
                                              }
                                    success:^(NSDictionary *data) {
                                        success(data);
                                    } failure:^(NSError *error) {                                                                 failure(error.userInfo[NSLocalizedDescriptionKey]);
                                    }];
}

+(void)editInfoWithfirst_name:(NSString *)first_name
                    last_name:(NSString *)last_name
                      success:(void (^)(NSDictionary *))success
                      failure:(void (^)(NSString *))failure {
    [[ICNetworkManager defaultManager] POST:@"Profile"
                              GETParameters:nil
                             POSTParameters:@{@"last_name":last_name,
                                              @"first_name":first_name}
                                    success:success failure:^(NSError *error) {
                                        failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                    }];
}

+(void)resetPassword:(NSString *)email
             success:(void (^)(NSString *))success
             failure:(void (^)(NSString *))failure {
    [[ICNetworkManager defaultManager] POST:@"Change Password"
                              GETParameters:@{@"reset":@"true"}
                             POSTParameters:@{@"email": email}
                                    success:^(NSDictionary *data) {
                                        success(@"success");
                                    } failure:^(NSError *error) {
                                        failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                    }];
}

+(void)refreshTokenWith:(void (^)(NSString *))failure {
    [[ICNetworkManager defaultManager] PUT:@"Login"
                             GETParameters:nil
                            POSTParameters:nil
                                   success:^(NSDictionary *data) {
                                       NSString *session = data[@"session_token"];
                                       [ICNetworkManager defaultManager].token = session;
                                       PJUser *user = [PJUser new];
                                       user.name = data[@"name"];
                                       user.first_name = data[@"first_name"];
                                       user.last_name = data[@"last_name"];
                                       user.last_login_date = data[@"last_login_date"];
                                       user.email = data[@"email"];
                                       [user save];
                                   } failure:^(NSError *error) {
                                       failure(error.userInfo[NSLocalizedDescriptionKey]);
                                   }];
}

+ (void)saveUserNameWithString:(NSString*)userName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"暂存用户邮箱"];
    [defaults synchronize];
}

+ (void)readUserNameWithBlock:(void (^)(NSString *))userName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"暂存用户邮箱"];
    userName(str);
}

@end
