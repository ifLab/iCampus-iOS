//
//  ICUser.m
//  iCampus
//
//  Created by Darren Liu on 14-4-27.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUser.h"
#import <CommonCrypto/CommonCrypto.h>
#import "ICNetworkManager.h"

ICUser *ICCurrentUser = nil;

@implementation ICUser

- (id)initWithToken:(NSString *)token
        expiresTime:(NSUInteger)expiresTime {
    self = [super init];
    if (self) {
        self.token = token;
        self.expiresTime = expiresTime;
    }
    return self;
}

- (BOOL)login {
    NSString *URLString = [NSString stringWithFormat:@"%@/m/userinfo.htm", ICAuthAPIURLPrefix];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", self.token]
   forHTTPHeaderField:@"Authorization"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    if (!data) {
        return NO;
    }
    NSString *jsonString = [[[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
    NSDictionary *information = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:kNilOptions
                                                      error:nil];
    self.ID = information[@"userName"];
    self.name = information[@"realName"];
    self.type = information[@"userType"];
    self.email = information[@"email"];
    self.avatarURL = [NSURL URLWithString:information[@"avatar"]];
    self.idCard = information[@"idCard"];
    self.active = [information[@"active"] isEqualToString:@"1"];
    self.department = information[@"department"];
    URLString = [NSString stringWithFormat:@"%@/userinfo.php?userid=%@", ICUserAPIURLPrefix, self.ID];
    URL = [NSURL URLWithString:URLString];
    request = [NSMutableURLRequest requestWithURL:URL];
    data = [NSURLConnection sendSynchronousRequest:request
                                 returningResponse:nil
                                             error:nil];
    if (!data) {
        return NO;
    }
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:nil];
    if (json.count < 1) {
        return NO;
    }
    information = json[0];
    self.QQ = information[@"qq"];
    self.WeChat = information[@"wechat"];
    self.mobile = information[@"mobile"];
    ICCurrentUser = self;
    return YES;
}

+ (void)registerWithEmail:(NSString *)email
                 password:(NSString *)password
                    phone:(NSString *)phone
                  success:(void (^)(ICUser *))success
                  failure:(void (^)(NSError *))failure {
    [[ICNetworkManager defaultManager] POST:@"Register"
                              GETParameters:nil
                             POSTParameters:@{
                                              @"email": email,
                                              @"password": password,
                                              @"phone": phone
                                              }
                                    success:^(NSDictionary *data) {
                                        [ICUser loginWithEmail:email
                                                        password:password success:success
                                                         failure:failure];
                                    }
                                    failure:failure];
}


+ (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void (^)(ICUser *))success
               failure:(void (^)(NSError *))failure {
    NSDictionary *POSTParameters = @{
                                     @"email": email,
                                     @"password": password,
                                     };
    NSDictionary *GETParameters = @{
                                    @"remember_m": @"true"
                                    };
    [[ICNetworkManager defaultManager] POST:@"Login"
                              GETParameters:GETParameters
                             POSTParameters:POSTParameters
                                    success:^(NSDictionary *data) {
                                        ICUser *user = [[ICUser alloc] init];
                                        user.token = data[@"session_token"];
                                        user.ID = data[@"id"];
                                        user.name = data[@"name"];
                                        user.email = data[@"email"];
                                        ICCurrentUser = user;
                                        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
                                        NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
                                        [plistData setObject:user.token forKey:@"Token"];
                                        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                                        NSString *plistPath1 = [paths objectAtIndex:0];
                                        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"Configuration.plist"];
                                        [plistData writeToFile:filename atomically:YES];
                                        success(user);
                                    }
                                    failure:^(NSError *error) {
                                        failure(error);
                                    }];
}

+ (void)refreshToken:(void (^)(ICUser *))success
             failure:(void (^)(NSError *))failure {
    [[ICNetworkManager defaultManager] PUT:@"Login"
                                parameters:nil
                                   success:^(NSDictionary *data) {
                                       ICUser *user = [[ICUser alloc] init];
                                       user.token = data[@"session_token"];
                                       user.ID = data[@"id"];
                                       user.name = data[@"name"];
                                       user.email = data[@"email"];
                                       ICCurrentUser = user;
                                       NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
                                       NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
                                       [plistData setObject:user.token forKey:@"Token"];
                                       NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                                       NSString *plistPath1 = [paths objectAtIndex:0];
                                       NSString *filename=[plistPath1 stringByAppendingPathComponent:@"Configuration.plist"];
                                       [plistData writeToFile:filename atomically:YES];
                                       success(user);
                                   }
                                   failure:failure];
}

- (NSString*)sha1:(NSString *)string {
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

@end
