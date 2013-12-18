//
//  ICNews.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-4.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICNews : NSObject

@property (nonatomic)       NSUInteger  index    ;
@property (nonatomic, copy) NSDate     *date     ;
@property (nonatomic, copy) NSString   *title    ;
@property (nonatomic, copy) NSString   *author   ;
@property (nonatomic, copy) NSString   *preview  ;
@property (nonatomic, copy) NSString   *detailKey;
@property (nonatomic, copy) NSURL      *imageURL ;

@end

#import "ICNewsChannel.h"
#import "ICNewsChannelList.h"
#import "ICNewsDetail.h"
#import "ICNewsDetailAttachment.h"
#import "ICNewsList.h"
