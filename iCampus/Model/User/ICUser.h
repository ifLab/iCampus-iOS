//
//  ICUser.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-4.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICUser : NSObject

@property (nonatomic, readonly, getter = isLoggedIn) BOOL        loggedIn;
@property (nonatomic, readonly)                      NSUInteger  idType;
@property (nonatomic, readonly)                      NSUInteger  identifier;
@property (nonatomic, readonly, copy)                NSString   *accessToken;
@property (nonatomic, readonly, copy)                NSString   *username;

+ (ICUser *)userWithUsername:(NSString *)username
                    password:(NSString *)password;
- (id)initWithUsername:(NSString *)username
              password:(NSString *)password;
- (BOOL)login;

@end
