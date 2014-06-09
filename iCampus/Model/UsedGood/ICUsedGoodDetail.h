//
//  ICUsedGoodDetail.h
//  iCampus
//
//  Created by EricLee on 14-4-8.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICUsedGood.h"
@interface ICUsedGoodDetail : NSObject
@property (nonatomic, copy) NSString   *title    ;
@property (nonatomic)       NSString   *ID       ;
@property (nonatomic, copy) NSString   *time     ;
@property (nonatomic, copy) NSString   *type     ;
@property (nonatomic)       NSString   *price    ;
@property (nonatomic, copy) NSString   *author   ;
@property (nonatomic, copy) NSString   *position ;
@property (nonatomic, copy) NSString   *preview  ;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSArray    *imageURLs;
@property (nonatomic, copy) NSString *Phone      ;
@property (nonatomic, copy) NSString *Email      ;
@property (nonatomic, copy) NSString *QQ         ;



+ (instancetype)UsedGoodDetailWithUsedGood:(ICUsedGood *)goods;

- (id)initWithUsedGood:(ICUsedGood *)good;

@end
