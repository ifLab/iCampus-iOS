//
//  ICJob.m
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJob.h"
#import "ICModelConfig.h"

@implementation ICJob

+ (id)loadJobDetailWith:(NSInteger)jobID {
    ICJob *job = [[ICJob alloc] init];
    if (job) {
        NSString *URLString = [NSString stringWithFormat:@"http://m.bistu.edu.cn/newapi/jobdetail.php?id=%ld", (long)jobID];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_JOB_DETAIL_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICJobDetailTag, ICFetchingTag, URLString);
#       endif
        NSURL *URL = [NSURL URLWithString:URLString];
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL]
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_JOB_DETAIL_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICJobDetailTag, ICFailedTag, ICNullTag, URLString);
#           endif
            return nil;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_JOB_DETAIL_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICJobDetailTag, ICSucceededTag, URLString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        NSDictionary *j = json[0];
        job.index          = [j[@"id"] intValue];
        job.title          = j[@"title"];
        job.introduction   = j[@"description"];
        job.location       = j[@"location"];
        job.qualifications = j[@"qualifications"];
        job.salary         = j[@"salary"];
        job.company        = j[@"company"];
        job.contactName    = j[@"contactName"];
        job.contactEmail   = j[@"contactEmail"];
        job.contactPhone   = j[@"contactPhone"];
        job.contactQQ      = j[@"contactQQ"];
        job.promulgatorID  = j[@"userid"];
    }
    return job;
}

@end
