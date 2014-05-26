//
//  ICJobClassificationList.m
//  iCampus
//
//  Created by Jerry Black on 14-4-20.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobClassificationList.h"

@implementation ICJobClassificationList

- (id)init {
    self = [super init];
    if (self) {
        self.jobClassificationList = [NSMutableArray array];
    }
    return self;
}

+ (id)loadJobClassificationList {
    ICJobClassificationList *jobClassificationList = [[ICJobClassificationList alloc] init];
    ICJobClassification *jobClassification;
    
    NSLog(@"兼职：开始获取分类列表，http://m.bistu.edu.cn/newapi/jobtype.php");
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.bistu.edu.cn/newapi/jobtype.php"]]
                                         returningResponse:nil
                                                     error:nil];
    if (!data) {
        NSLog(@"兼职：获取分类列表错误");
        return nil;
    }
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:nil];
    jobClassification = [[ICJobClassification alloc] init];
    jobClassification.index = 0;
    jobClassification.title = @"全部";
    [jobClassificationList.jobClassificationList addObject:jobClassification];
    for (NSDictionary *c in json) {
        jobClassification = [[ICJobClassification alloc] init];
        jobClassification.index = [c[@"id"] intValue];
        jobClassification.title = c[@"name"];
        [jobClassificationList.jobClassificationList addObject:jobClassification];
    }
    if ((unsigned long)jobClassificationList.jobClassificationList.count == 1) {
        NSLog(@"兼职：获取分类列表错误");
        return nil;
    }
    NSLog(@"兼职：获取类型数量%lu", (unsigned long)jobClassificationList.jobClassificationList.count);
    return jobClassificationList;
}

@end
