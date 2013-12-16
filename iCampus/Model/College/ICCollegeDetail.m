//
//  ICCollegeDetail.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICCollegeDetail.h"
#import "ICCollege.h"
#import "../ICModuleConfig.h"

@implementation ICCollegeDetail

+ (ICCollegeDetail *)collegeDetailWithCollege:(ICCollege *)college {
    return [[self alloc] initWithCollege:college];
}

- (id)initWithCollege:(ICCollege *)college {
    self = [super init];
    if (self) {
        if (!college) {
            return self;
        }
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=collegeintro&action=detail&mod=%@&id=%lu", ICCollegeServerDomain, college.mark, (unsigned long)college.index];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_COLLEGE_MODULE_DETAIL_DEBUG__)
            NSLog(@"%@ %@ %@", ICCollegeDetailTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef __IC_COLLEGE_MODULE_DETAIL_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICCollegeDetailTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return self;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_COLLEGE_MODULE_DETAIL_DEBUG__)
            NSLog(@"%@ %@ %@", ICCollegeDetailTag, ICSucceededTag, urlString);
#       endif
        NSDictionary *json = [[NSJSONSerialization JSONObjectWithData:data
                                                              options:kNilOptions
                                                                error:nil] firstObject];
        self.index = [[json objectForKey:@"id"] intValue];
        self.mark = [json objectForKey:@"mark"];
        self.name = [json objectForKey:@"introName"];
        self.body = [json objectForKey:@"introCont"];
        self.rank = [[json objectForKey:@"rank"] intValue];
    }
    return self;
}

@end
