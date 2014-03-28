//
//  ICNewsChannelList.m
//  iCampus
//
//  Created by Darren Liu on 13-12-15.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsChannel.h"
#import "ICNewsChannelList.h"
#import "../ICModelConfig.h"

@interface ICNewsChannelList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICNewsChannelList

+ (ICNewsChannelList *)channelList {
    ICNewsChannelList *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=newschannel", ICNewsServerDomain];
        NSURL *url = [NSURL URLWithString:urlString];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_NEWS_CHANNEL_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICNewsChannelTag, ICFetchingTag, urlString);
#       endif
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef __IC_NEWS_CHANNEL_DATA_MODULE_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICNewsChannelTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return instance;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_NEWS_CHANNEL_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICNewsChannelTag, ICSucceededTag, urlString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:(NSString *)ICTimeZoneName];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        for (NSDictionary __strong *a in json) {
            a = a[@"attributes"];
            ICNewsChannel *channel = [[ICNewsChannel alloc] init];
            channel.index = [a[@"id"] intValue];
            channel.lastUpdateDate = [dateFormatter dateFromString:a[@"lmt"]];
            channel.title = a[@"n"];
            channel.listKey = a[@"url"];
            channel.listKey = [channel.listKey stringByReplacingOccurrencesOfString:@"http://newsfeed.bistu.edu.cn"
                                                                         withString:@""];
            [instance addChannel:channel];
        }
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addChannel:(ICNewsChannel *)channel {
    [self.array addObject:channel];
}

- (void)addChannelsFromChannelList:(ICNewsChannelList *)channelList {
    [self.array addObjectsFromArray:channelList.array];
}

- (void)removeChannel:(ICNewsChannel *)channel {
    [self.array removeObject:channel];
}

- (NSUInteger)count {
    return self.array.count;
}

- (ICNewsChannel *)firstChannel {
    return self.array.firstObject;
}

- (ICNewsChannel *)lastChannel {
    return self.array.lastObject;
}

- (ICNewsChannel *)channelAtIndex:(NSUInteger)index {
    return (self.array)[index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state
                                           objects:buffer
                                             count:len];
}

@end
