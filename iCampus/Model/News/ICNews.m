//
//  ICNews.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-4.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICNews.h"
#import "ICNetworkManager.h"

@implementation ICNews

+(void)fetchNews:(ICNewsChannel *)channel
            page:(NSInteger)page
         success:(void(^)(NSArray*))success
         failure:(void(^)(NSString*))failure {
    [[ICNetworkManager defaultManager] GET:@"News List"
                                parameters:@{
                                             @"category": channel.listKey,
                                             @"page": @(page),
                                             }
                                   success:^(NSDictionary *dic) {
                                       NSArray *data = dic[@"resource"];
                                       NSMutableArray *array = [[NSMutableArray alloc] init];
                                       for (NSDictionary *element in data) {
                                           ICNews *news = [[ICNews alloc] init];
                                           news.title = element[@"newsTitle"];
                                           news.date = element[@"newsTime"];
                                           news.detailKey = element[@"newsLink"];
                                           news.imageURL = element[@"newsImage"];
                                           news.preview = element[@"newsIntro"];
                                           [array addObject:news];
                                       }
                                       success(array);
                                   }
                                   failure:^(NSError *error) {
                                       failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                   }];
}
@end
