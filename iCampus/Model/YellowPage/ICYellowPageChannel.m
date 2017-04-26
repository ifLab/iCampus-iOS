//
//  ICYellowPageChannel.m
//  iCampus
//
//  Created by Bill Hu on 2017/4/22.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "ICYellowPageChannel.h"
#import "ICNetworkManager.h"
#import "ICYellowPage.h"

@implementation ICYellowPageChannel

+(void)fetchYellowPageChannel:(void(^)(NSArray*))success
                      failure:(void(^)(NSString*))failure {
    [[ICNetworkManager defaultManager] GET:@"Yellow Page Channel"
                                parameters:nil
                                   success:^(NSDictionary *dic) {
                                       NSArray *data = dic[@"resource"];;
                                       NSMutableArray *pages = [[NSMutableArray alloc] init];
                                       for (NSDictionary *object in data) {
                                           ICYellowPageChannel *channel = [[ICYellowPageChannel alloc] init];
                                           channel.name = object[@"name"];
                                           channel.department = object[@"department"];
                                           [pages addObject:channel];
                                       }
                                       success(pages);
                                   }
                                   failure:^(NSError *error) {
                                       failure(error.userInfo[NSLocalizedDescriptionKey]);
                                   }];
}

@end
