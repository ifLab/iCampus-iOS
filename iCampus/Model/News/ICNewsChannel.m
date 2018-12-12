//
//  ICNewsChannel.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICNewsChannel.h"
#import "ICNetworkManager.h"

@implementation ICNewsChannel

+ (void)getChannelWithSuccess:(void (^)(NSArray<ICNewsChannel *> *))success failure:(void (^)(NSError *))failure{
    [ICNetworkManager.defaultManager GET:@"http://newsfeed.bistu.edu.cn/ibistu/channel.json" parameters:nil success:^(NSDictionary *res) {
        if([res[kMsgCode] integerValue] == 1) {
            NSMutableArray<ICNewsChannel *> *array = [@[] mutableCopy];
            for(NSDictionary *dict in res[kMsg][@"docchannel"]) {
                ICNewsChannel *channel = [ICNewsChannel mj_objectWithKeyValues:dict];
                [array addObject:channel];
            }
            
            success(array);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSString *)chnlurl {
    NSArray *temp = [_chnlurl componentsSeparatedByString:@"/"];
    return temp.count - 2 >= 0 ? temp[temp.count - 2] : nil;
}

@end
