//
//  ICUsedGood.h
//  iCampus
//
//  Created by EricLee on 14-4-8.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICUsedGoodType;

@interface ICUsedGood : NSObject

@property (nonatomic, copy) NSString            *description  ;
@property (nonatomic, copy) NSString            *ID           ;
@property (nonatomic, copy) NSMutableArray      *imageURLs    ;
@property (nonatomic, copy) NSString            *price        ;
@property (nonatomic, copy) NSString            *time         ;
@property (nonatomic, copy) NSString            *title        ;
@property (nonatomic, copy) NSString            *typeID       ;
@property (nonatomic, copy) NSNumber            *userID       ;
@property (nonatomic, copy) NSNumber            *position     ;
@property (nonatomic, copy) NSString            *author       ;
@property (nonatomic, copy) NSString            *preview      ;
@property (nonatomic, copy) NSString            *Phone        ;
@property (nonatomic, copy) NSString            *Email        ;
@property (nonatomic, copy) NSString            *QQ           ;



+ (NSArray *)goodListWithType:(ICUsedGoodType *)type;
+ (NSArray *)goodListWithUserID:(NSString *)userID ;
@end
