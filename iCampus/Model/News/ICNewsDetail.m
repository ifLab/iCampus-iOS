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
                                       news.pcURL = dic[@"imgList"];
                                       news.body = [NSString stringWithFormat:@"<body><p>%@</p></body>", dic[@"article"]];
                                       news.body = [news.body stringByReplacingOccurrencesOfString:@"\n" withString:@"</p><p>"];
                                       news.body = [news.body stringByReplacingOccurrencesOfString:@"<p> </p>" withString:@"<p></p>"];
                                       for (int i=0; i<news.pcURL.count; i++) {
                                           @try {
                                               news.body = [news.body stringByReplacingCharactersInRange:[news.body rangeOfString:@"<p></p><p></p>"] withString:[NSString stringWithFormat:@"<img src=\"%@\">", news.pcURL[i]]];
                                           } @catch (NSException *exception) {
                                               if ([exception.name isEqualToString:NSRangeException]) {
                                                   break;
                                               }
                                           }
                                       }
                                       success(news);
                                   }
                                   failure:^(NSError *error) {
                                       failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                   }];
}

@end
