//
//  ICJobList.m
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobList.h"
#import "ICJobClassification.h"
#import "ICJob.h"
#import "ICModelConfig.h"

@implementation ICJobList

- (id)init {
    self = [super init];
    if (self) {
        self.jobList = [NSMutableArray array];
    }
    return self;
}

+ (id)loadJobListWithType:(BOOL)type
           classification:(ICJobClassification *)classification {
    ICJobList *list = [[ICJobList alloc] init];
    if (list) {
        NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@/job.php?mod=%@", ICJobAPIURLPrefix, type ? @"1" : @"2"];
        if (classification.index != 0) {
            [URLString appendFormat:@"&typeid=%lu", (unsigned long)classification.index];
        }
        NSURL *URL = [NSURL URLWithString:URLString];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_JOB_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICJobListTag, ICFetchingTag, URLString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL]
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_JOB_LIST_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICJobListTag, ICFailedTag, ICNullTag, URLString);
#           endif
            return nil;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_JOB_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICJobListTag, ICSucceededTag, URLString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        for (NSDictionary *j in json) {
            ICJob *job = [[ICJob alloc] init];
            job.index = [j[@"id"] intValue];
            job.title = j[@"title"];
            [list.jobList addObject:job];
        }
    }
    return list;
}

+ (id)loadJobListWithID:(NSString *)userID {
    ICJobList *list = [[ICJobList alloc] init];
    if (list) {
        NSString *URLString = [NSString stringWithFormat:@"%@/job.php?userid=%@", ICJobAPIURLPrefix, userID];
        NSURL *URL = [NSURL URLWithString:URLString];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_JOB_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICJobListTag, ICFetchingTag, URLString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL]
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_JOB_LIST_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICJobListTag, ICFailedTag, ICNullTag, URLString);
#           endif
            return nil;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_JOB_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICJobListTag, ICSucceededTag, URLString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        for (NSDictionary *j in json) {
            ICJob *job = [[ICJob alloc] init];
            job.index = [j[@"id"] intValue];
            job.title = j[@"title"];
            [list.jobList addObject:job];
        }
    }
    return list;
}

@end
