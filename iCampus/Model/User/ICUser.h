//
//  ICUser.h
//  iCampus
//
//  Created by Darren Liu on 14-4-27.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICAppDelegate.h"

@interface ICUser : NSObject

@property (nonatomic, copy) NSString   *token      ;
@property (nonatomic)       NSUInteger  expiresTime;
@property (nonatomic, copy) NSString   *name       ;
@property (nonatomic, copy) NSString   *ID         ;
@property (nonatomic, copy) NSString   *type       ;
@property (nonatomic, copy) NSString   *QQ         ;
@property (nonatomic, copy) NSString   *WeChat     ;
@property (nonatomic, copy) NSString   *mobile     ;
@property (nonatomic, copy) NSString   *email      ;

- (id)initWithToken:(NSString *)token
        expiresTime:(NSUInteger)expiresTime;

- (BOOL)login;

@end

#define ICCurrentUser ((ICAppDelegate *)[UIApplication sharedApplication].delegate).user
