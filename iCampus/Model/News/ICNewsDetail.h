//
//  ICNewsDetail.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-6.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICNews, ICNewsList;

@interface ICNewsDetail : NSObject

@property (nonatomic)       NSUInteger  sourceIndex       ;
@property (nonatomic)       NSUInteger  channelIndex      ;
@property (nonatomic)       NSUInteger  type              ;
@property (nonatomic, copy) NSString   *title             ;
@property (nonatomic, copy) NSArray    *subtitles         ;
@property (nonatomic, copy) NSArray    *authors           ;
@property (nonatomic, copy) NSArray    *sourceNames       ;
@property (nonatomic, copy) NSDate     *sourceCreationTime;
@property (nonatomic, copy) NSDate     *modificationTime  ;
@property (nonatomic, copy) NSString   *creator           ;
@property (nonatomic, copy) NSDate     *creationTime      ;
@property (nonatomic, copy) NSString   *abstract          ;
@property (nonatomic, copy) NSString   *body              ;
@property (nonatomic, copy) NSArray    *pcURL             ;
@property (nonatomic, copy) NSArray    *attachments       ;
@property (nonatomic, copy) NSArray    *imageURLs         ;

+ (void)newsDetailWithNews:(ICNews *)news
                   success:(void (^)(ICNewsDetail*))success
                   failure:(void (^)(NSString*))failure;

@end
