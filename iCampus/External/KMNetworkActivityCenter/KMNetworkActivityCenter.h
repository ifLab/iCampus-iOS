//
//  KMNetworkActivityCenter.h
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-9-11.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMNetworkActivityCenter : NSObject

@property (nonatomic, readonly) NSUInteger networkingCount;

+ (KMNetworkActivityCenter *)sharedCenter;

- (void)addNetworkingAction;
- (void)removeNetworkingAction;

@end
