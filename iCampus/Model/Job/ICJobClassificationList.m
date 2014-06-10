//
//  ICJobClassificationList.m
//  iCampus
//
//  Created by Jerry Black on 14-4-20.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobClassificationList.h"
#import "ICModelConfig.h"
#import "ICJobClassification.h"

@implementation ICJobClassificationList

- (instancetype)init {
    self = [super init];
    if (self) {
        _jobClassificationList = [NSMutableArray array];
    }
    return self;
}

+ (id)loadJobClassificationList {
    ICJobClassificationList *jobClassificationList = [[ICJobClassificationList alloc] init];
    if (jobClassificationList) {
        NSString *URLString = @"http://m.bistu.edu.cn/newapi/jobtype.php";
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_JOB_CLASSIFICATION_DATA_MODULE_DEBUG)
        NSLog(@"%@ %@ %@", ICJobClassificationTag, ICFetchingTag, URLString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.bistu.edu.cn/newapi/jobtype.php"]]
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_JOB_CLASSIFICATION_DATA_MODULE_DEBUG
            NSLog(@"%@ %@ %@ %@", ICJobClassificationTag, ICFailedTag, ICNullTag, URLString);
#           endif
            return nil;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_JOB_CLASSIFICATION_DATA_MODULE_DEBUG)
        NSLog(@"%@ %@ %@", ICJobClassificationTag, ICSucceededTag, URLString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        ICJobClassification *jobClassification = [[ICJobClassification alloc] init];
        jobClassification.index = 0;
        jobClassification.title = @"全部";
        [jobClassificationList.jobClassificationList addObject:jobClassification];
        for (NSDictionary *c in json) {
            jobClassification = [[ICJobClassification alloc] init];
            jobClassification.index = [c[@"id"] intValue];
            jobClassification.title = c[@"name"];
            [jobClassificationList.jobClassificationList addObject:jobClassification];
        }
    }
    return jobClassificationList;
}

@end
