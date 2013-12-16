//
//  ICNewsList.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-6.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICNews, ICNewsChannel;

@interface ICNewsList : NSObject <NSFastEnumeration>

+ (ICNewsList *)newsListWithChannel:(ICNewsChannel *)channel
                          pageIndex:(NSUInteger)index;
+ (ICNewsList *)newsListWithKeyword:(NSString *)keyword;
- (id)initWithChannel:(ICNewsChannel *)channel
            pageIndex:(NSUInteger)index;
- (id)initWithKeyword:(NSString *)keyword;
- (void)addNews:(ICNews *)news;
- (void)addNewsFromNewsList:(ICNewsList *)newsList;
- (void)removeNews:(ICNews *)news;
- (NSUInteger)count;
- (ICNews *)firstNews;
- (ICNews *)lastNews;
- (ICNews *)newsAtIndex:(NSUInteger)index;

@end
