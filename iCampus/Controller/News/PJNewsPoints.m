//
//  PJNewsPoints.m
//  iCampus
//
//  Created by pjpjpj on 2018/1/5.
//  Copyright © 2018年 ifLab. All rights reserved.
//

#import "PJNewsPoints.h"

@implementation PJNewsPoints

+ (void)setNewsPoint:(NSDictionary *)param {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSMutableDictionary *dict = [param mutableCopy];
    dict[@"uploadtime"] = dateString;
    
    [MobClick event:@"ibistu_news_details" attributes:dict];
}

+ (void)setNewsShare {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    [MobClick event:@"ibistu_news_details_share" attributes:@{
                                                   @"username" : [PJUser currentUser].first_name,
                                                   @"uploadtime" : dateString
                                                   }];
}

@end
