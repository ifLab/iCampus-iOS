//
//  ICYellowPage.m
//  iCampus
//
//  Created by Bill Hu on 2017/4/22.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "ICYellowPage.h"
#import "ICNetworkManager.h"

@implementation ICYellowPage

+(void)fetchYellowPageWith:(ICYellowPageChannel *)channel
                   success:(void(^)(NSArray*))success
                   failure:(void(^)(NSString*))failure {
    NSString *department = [NSString stringWithFormat:@"department=%@", channel.department];
    [[ICNetworkManager defaultManager] GET:@"Yellow Page"
                                parameters:@{
                                             @"offset": @1,
                                             @"filter": department
                                             }
                                   success:^(NSDictionary *dic) {
                                       NSArray *data = dic[@"resource"];
                                       NSMutableArray *yellowPages = [[NSMutableArray alloc] init];
                                       for (NSDictionary *object in data) {
                                           if ([object[@"isDisplay"] isEqual: @"true"]) {
                                               ICYellowPage *yellowPage = [[ICYellowPage alloc] init];
                                               yellowPage.name = object[@"name"];
                                               yellowPage.telephone = object[@"telephone"];
                                               [yellowPages addObject:yellowPage];
                                           }
                                       }
                                       success(yellowPages);
                                   } failure:^(NSError *error) {
                                       failure(error.userInfo[NSLocalizedDescriptionKey]);
                                   }];
}

@end
