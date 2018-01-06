//
//  ICNews.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-4.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.

#import <Foundation/Foundation.h>
#import "ICNewsChannel.h"
#import "ICNewsDetail.h"


@interface ICNews : NSObject

@property (nonatomic)       NSUInteger  index    ;
@property (nonatomic, copy) NSString   *date     ;
@property (nonatomic, copy) NSString   *title    ;
@property (nonatomic, copy) NSString   *author   ;
@property (nonatomic, copy) NSString   *preview  ;
@property (nonatomic, copy) NSString   *detailKey;
@property (nonatomic, copy) NSString   *imageURL ;

+(void)fetchNews:(ICNewsChannel *)channel
            page:(NSInteger)page
         success:(void(^)(NSArray*))success
         failure:(void(^)(NSString*))failure;

@end
