//
//  ICUser.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-4.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICUser.h"
#import "../../External/NSString+RSA/NSString+RSA.h"
#import "../ICModelConfig.h"

@interface ICUser ()

@property (nonatomic, copy) NSString *password;

@end

@implementation ICUser

+ (ICUser *)userWithUsername:(NSString *)username
                    password:(NSString *)password {
    return [[self alloc] initWithUsername:username
                                 password:password];
}

- (id)initWithUsername:(NSString *)username
              password:(NSString *)password {
    self = [super init];
    _loggedIn = NO;
    if (self) {
        _username = username;
        self.password = password;
    }
    return self;
}

- (BOOL)login {
    _loggedIn = NO;
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=member&action=getloginkey_ios_der", ICUserServerDomain];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
#   if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_USER_DATA_MODULE_DEBUG)
        NSLog(@"%@ %@ %@", ICUserTag, ICFetchingTag, urlString);
#   endif
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    if (!data) {
#       ifdef IC_USER_DATA_MODULE_DEBUG
            NSLog(@"%@ %@ %@ Could not fetch RSA public key.", ICUserTag, ICFailedTag, ICNullTag);
#       endif
        return NO;
    }
    NSString *dataString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\\n"
                                                       withString:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\\r"
                                                       withString:@""];
    NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:kNilOptions
                                                       error:nil];
    NSString *rsaPublicKey = array[0];
    if (!rsaPublicKey) {
#       ifdef IC_USER_DATA_MODULE_DEBUG
            NSLog(@"%@ %@ %@ Could not fetch RSA public key.", ICUserTag, ICFailedTag, ICBrokenTag);
#       endif
        return NO;
    }
#   if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_USER_DATA_MODULE_DEBUG)
        NSLog(@"%@ %@ RSA public key length: %lu", ICUserTag, ICSucceededTag, (unsigned long)rsaPublicKey.length);
#   endif
    NSString *rsaEncryptedString = [[NSString stringWithFormat:@"%@|%@|%.0f",
                                     _username, self.password, [[NSDate date] timeIntervalSince1970]]
                                    rsaEncryptedStringWithPublicKey:rsaPublicKey];
    rsaEncryptedString = [rsaEncryptedString stringByReplacingOccurrencesOfString:@"+"
                                                                       withString:@"*"];
    urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=member&action=login_ios&info=%@",
                 ICUserServerDomain, rsaEncryptedString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:urlString];
    request = [NSURLRequest requestWithURL:url];
#   if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_USER_DATA_MODULE_DEBUG)
        NSLog(@"%@ %@ %@", ICUserTag, ICFetchingTag, urlString);
#   endif
    data = [NSURLConnection sendSynchronousRequest:request
                                 returningResponse:nil
                                             error:nil];
    dataString = [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
    if ([dataString isEqualToString:@"-20001"] || [dataString isEqualToString:@"-20002"]) {
#       ifdef IC_USER_DATA_MODULE_DEBUG
            NSLog(@"%@ %@ Username didn't match the password.", ICUserTag, ICFailedTag);
#       endif
        return NO;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:nil];
    _accessToken = [json[@"accessToken"] copy        ];
    _idType      = [json[@"idtype"] integerValue];
    _identifier  = [json[@"userid"] integerValue];
    _username    = [json[@"username"] copy        ];
    _loggedIn    = YES;
#   if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_USER_DATA_MODULE_DEBUG)
        NSLog(@"%@ %@ User %@ logged in successfully with password '%@'", ICUserTag, ICSucceededTag, _username, self.password);
#   endif
    return YES;
}

@end
