//
//  KMNetworkActivityCenter.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-9-11.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMNetworkActivityCenter.h"

@interface KMNetworkActivityCenter ()

@property (nonatomic, readwrite) NSUInteger networkingCount;

@end

@implementation KMNetworkActivityCenter

+ (KMNetworkActivityCenter *)sharedCenter
{
    static KMNetworkActivityCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KMNetworkActivityCenter alloc] init];
    });
    return sharedInstance;
}

- (void)addNetworkingAction
{
    self.networkingCount++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)removeNetworkingAction
{
    self.networkingCount--;
    if (self.networkingCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

@end
