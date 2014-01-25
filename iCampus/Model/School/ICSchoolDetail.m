//
//  ICSchoolDetail.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICSchoolDetail.h"
#import "ICSchool.h"
#import "../ICModelConfig.h"

@implementation ICSchoolDetail

+ (ICSchoolDetail *)schoolDetailWithSchool:(ICSchool *)school {
    return [[self alloc] initWithSchool:school];
}

- (id)initWithSchool:(ICSchool *)school {
    self = [super init];
    if (self) {
        if (!school) {
            return self;
        }
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=collegeintro&action=detail&mod=%@&id=%lu", ICSchoolServerDomain, school.mark, (unsigned long)school.index];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_SCHOOL_DETAIL_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICSchoolDetailTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_SCHOOL_DETAIL_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICSchoolDetailTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return self;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_SCHOOL_DETAIL_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICSchoolDetailTag, ICSucceededTag, urlString);
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
