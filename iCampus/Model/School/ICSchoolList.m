//
//  ICSchoolList.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICSchoolList.h"
#import "ICSchool.h"
#import "../ICModelConfig.h"

@interface ICSchoolList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICSchoolList

+ (ICSchoolList *)schoolList {
    ICSchoolList *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=collegeintro", ICSchoolServerDomain];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_SCHOOL_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICSchoolListTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_SCHOOL_LIST_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICSchoolListTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return nil;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_SCHOOL_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICSchoolListTag, ICSucceededTag, urlString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:nil];
        for (NSDictionary *a in json) {
            ICSchool *school = [[ICSchool alloc] init];
            school.index = [a[@"id"] intValue];
            school.name = a[@"introName"];
            school.mark = a[@"mod"];
            [instance addSchool:school];
        }
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (void)addSchool:(ICSchool *)school {
    [self.array addObject:school];
}

- (void)addSchoolFromSchoolList:(ICSchoolList *)schoolList {
    [self.array addObjectsFromArray:schoolList.array];
}

- (void)removeSchool:(ICSchool *)school {
    [self.array removeObject:school];
}

- (ICSchool *)firstSchool {
    return self.array.firstObject;
}

- (ICSchool *)lastSchool {
    return self.array.lastObject;
}

- (NSUInteger)count {
    return self.array.count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state
                                           objects:buffer
                                             count:len];
}

- (ICSchool *)schoolAtIndex:(NSUInteger)index {
    return (self.array)[index];
}

@end
