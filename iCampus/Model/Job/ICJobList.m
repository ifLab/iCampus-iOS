//
//  ICJobList.m
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobList.h"

@interface ICJobList ()

@property NSURL *url;

@end

@implementation ICJobList

- (id)init {
    self = [super init];
    if (self) {
        self.jobList = [NSMutableArray array];
    }
    return self;
}

+ (id)loadJobListWithType:(BOOL)type
           classification:(ICJobClassification*)classification {
    ICJobList *list = [[ICJobList alloc] init];
    ICJob *job;
    
    NSString *u = [NSString stringWithFormat:@"http://m.bistu.edu.cn/newapi/job.php"];
    if (classification.index == 0) {
        u = [NSString stringWithFormat:@"%@?mod=%@", u, (type ? @"1" : @"2")];
    } else {
        u = [NSString stringWithFormat:@"%@%@&typeid=%lu", u, (type ? @"?mod=2" : @"?mod=1"), (unsigned long)classification.index];
    }
    list.url = [NSURL URLWithString:u];
    NSLog(@"兼职：开始获取工作列表，%@", list.url);
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:list.url]
                                         returningResponse:nil
                                                     error:nil];
    if (!data) {
        NSLog(@"兼职：获取工作列表错误");
        return nil;
    }
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:nil];
    for (NSDictionary *j in json) {
        job = [[ICJob alloc] init];
        job.index = [j[@"id"] intValue];
        job.title = j[@"title"];
        [list.jobList addObject:job];
    }
    NSLog(@"兼职：获取工作个数：%lu", (unsigned long)list.jobList.count);
    return list;
}

@end
