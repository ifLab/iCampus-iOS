//
//  ICNewsDetail.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-6.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICNewsDetail.h"
#import "ICNews.h"
#import "ICNetworkManager.h"

@interface ICNewsDetail ()

@property (nonatomic, strong) NSArray *images;

@end

@implementation ICNewsDetail

+ (void)newsDetailWithNews:(ICNews *)news
                   success:(void (^)(ICNewsDetail*))success
                   failure:(void (^)(NSString*))failure{
    [[ICNetworkManager defaultManager] GET:@"News Detail"
                                parameters:@{
                                             @"link": news.detailKey
                                             }
                                   success:^(NSDictionary *dic) {
                                       ICNewsDetail *news = [[ICNewsDetail alloc] init];
                                       news.title = dic[@"title"];
                                       news.creationTime = dic[@"time"];
                                       news.body = dic[@"article"];
                                       news.pcURL = dic[@"imgList"];
                                       success(news);
                                   }
                                   failure:^(NSError *error) {
                                       failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                   }];
}

@end
