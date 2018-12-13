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
    [[ICNetworkManager defaultManager] GET:news.docpuburl
                                parameters:@{
//                                             @"link": news.detailKey
                                             }
                                   success:^(NSDictionary *dic) {
                                       if([dic[kMsgCode] intValue] == 3){
                                           ICNewsDetail *news = [ICNewsDetail mj_objectWithKeyValues:dic[kMsg][@"docdetail"]];
                                           success(news);
                                       }else{
                                           failure(@"内容加载失败");
                                       }

                                   }
                                   failure:^(NSError *error) {
                                       failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                   }];
}

@end
