//
//  ICNewsList.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-6.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICNewsList.h"
#import "ICNews.h"
#import "ICNewsChannel.h"
#import "../ICModuleConfig.h"

@interface ICNewsList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICNewsList

+ (ICNewsList *)newsListWithChannel:(ICNewsChannel *)channel
                          pageIndex:(NSUInteger)index {
    return [[self alloc] initWithChannel:channel
                               pageIndex:index];
}

+ (ICNewsList *)newsListWithKeyword:(NSString *)keyword {
    return [[self alloc] initWithKeyword:keyword];
}

- (id)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (id)initWithChannel:(ICNewsChannel *)channel
            pageIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
        if (!channel) {
            return self;
        }
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=newslist&url=%@&index=%lu", ICNewsServerDomain, channel.listKey, (unsigned long)index];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_NEWS_MODULE_LIST_DEBUG__)
            NSLog(@"%@ %@ %@", ICNewsListTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef __IC_NEWS_MODULE_LIST_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICNewsListTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return self;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_NEWS_MODULE_LIST_DEBUG__)
            NSLog(@"%@ %@ %@", ICNewsListTag, ICSucceededTag, urlString);
#       endif
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        json = [json objectForKey:@"d"];
        NSDateFormatter   *dateFormatter;
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:(NSString *)ICTimeZoneName]];
        for (NSMutableDictionary __strong *a in json) {
            a = [a objectForKey:@"attributes"];
            ICNews *news = [[ICNews alloc] init];
            news.index = [[a objectForKey:@"id"] intValue];
            news.date = [dateFormatter dateFromString:[a objectForKey:@"rt"]];
            news.title = [a objectForKey:@"n"];
            news.author = [a objectForKey:@"au"];
            news.preview = [a objectForKey:@"ab"];
            news.iconUrl = [NSURL URLWithString:[a objectForKey:@"ic"]];
            news.detailKey = [a objectForKey:@"url"];
            news.detailKey = [news.detailKey stringByReplacingOccurrencesOfString:@"http://newsfeed.bistu.edu.cn"
                                                                       withString:@""];
            news.detailKey = [news.detailKey stringByReplacingOccurrencesOfString:@".xml"
                                                                       withString:@""];
            [self.array addObject:news];
        }
    }
    return self;
}

- (id)initWithKeyword:(NSString *)keyword {
    self = [super init];
    if (self) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=newssearch&search=%@", ICNewsServerDomain, keyword];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_NEWS_MODULE_LIST_DEBUG__)
            NSLog(@"%@ %@ %@", ICNewsListTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef __IC_NEWS_MODULE_LIST_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICNewsListTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return self;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_NEWS_MODULE_LIST_DEBUG__)
            NSLog(@"%@ %@ %@", ICNewsListTag, ICSucceededTag, urlString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        NSDateFormatter   *dateFormatter;
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:(NSString *)ICTimeZoneName]];
        self.array = [NSMutableArray array];
        for (NSDictionary __strong *a in json) {
            a = [a objectForKey:@"attributes"];
            ICNews *news = [[ICNews alloc] init];
            news.index = [[a objectForKey:@"id"] intValue];
            news.date = [dateFormatter dateFromString:[a objectForKey:@"rt"]];
            news.title = [a objectForKey:@"n"];
            [self addNews:news];
        }
    }
    return self;
}

- (void)addNews:(ICNews *)news {
    [self.array addObject:news];
}

- (void)addNewsFromNewsList:(ICNewsList *)newsList {
    [self.array addObjectsFromArray:newsList.array];
}

- (void)removeNews:(ICNews *)news {
    [self.array removeObject:news];
}

- (NSUInteger)count {
    return self.array.count;
}

- (ICNews *)firstNews {
    return self.array.firstObject;
}

- (ICNews *)lastNews {
    return self.array.lastObject;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state
                                           objects:buffer
                                             count:len];
}

- (ICNews *)newsAtIndex:(NSUInteger)index {
    return [self.array objectAtIndex:index];
}

@end
