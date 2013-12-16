//
//  ICNewsChannelList.h
//  iCampus
//
//  Created by Darren Liu on 13-12-15.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICNewsChannel;

@interface ICNewsChannelList : NSObject <NSFastEnumeration>

+ (ICNewsChannelList *)channelList;
- (void)addChannel:(ICNewsChannel *)channel;
- (void)addChannelsFromChannelList:(ICNewsChannelList *)channelList;
- (void)removeChannel:(ICNewsChannel *)channel;
- (NSUInteger)count;
- (ICNewsChannel *)firstChannel;
- (ICNewsChannel *)lastChannel;
- (ICNewsChannel *)channelAtIndex:(NSUInteger)index;

@end
