//
//  BlogModel.m
//  iCampus
//
//  Created by 徐正科 on 2018/12/15.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import "BlogModel.h"
#import "UserModel.h"

#import "ICNetworkManager.h"

@implementation BlogModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"masuser": MasUser.class
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"blog_id": @"id"
             };
}

+ (void)getBlogsWithPage:(NSInteger)page success:(void (^)(NSArray<BlogModel *> * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure {
    [[ICNetworkManager defaultManager] GET:@"Blog" parameters:@{ @"page": @(page)} success:^(NSDictionary *dic) {
        NSMutableArray<BlogModel *> *array = [NSMutableArray array];
        for(NSDictionary *data in dic[kMsg][@"blogs"]) {
            BlogModel *blog = [BlogModel mj_objectWithKeyValues:data];
            [array addObject:blog];
        }
        success([array copy]);
    } failure:^(NSError *error) {
        failure(@"请求Blog失败");
    }];
}

@end
