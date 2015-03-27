//
//  ICUser.m
//  iCampus
//
//  Created by Darren Liu on 14-4-27.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUser.h"

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

@end
