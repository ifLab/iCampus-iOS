//
//  ICCollegeList.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICCollegeList.h"
#import "ICCollege.h"
#import "../ICModuleConfig.h"

@interface ICCollegeList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICCollegeList

+ (ICCollegeList *)collegeList {
    ICCollegeList *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=collegeintro", ICCollegeServerDomain];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_COLLEGE_MODULE_LIST_DEBUG__)
            NSLog(@"%@ %@ %@", ICCollegeListTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef __IC_COLLEGE_MODULE_LIST_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICCollegeListTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return nil;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_COLLEGE_MODULE_LIST_DEBUG__)
            NSLog(@"%@ %@ %@", ICCollegeListTag, ICSucceededTag, urlString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:nil];
        for (NSDictionary *a in json) {
            ICCollege *college = [[ICCollege alloc] init];
            college.index = [[a objectForKey:@"id"] intValue];
            college.name = [a objectForKey:@"introName"];
            college.mark = [a objectForKey:@"mod"];
            [instance addCollege:college];
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

- (void)addCollege:(ICCollege *)college {
    [self.array addObject:college];
}

- (void)addCollegeFromCollegeList:(ICCollegeList *)collegeList {
    [self.array addObjectsFromArray:collegeList.array];
}

- (void)removeCollege:(ICCollege *)college {
    [self.array removeObject:college];
}

- (ICCollege *)firstCollege {
    return self.array.firstObject;
}

- (ICCollege *)lastCollege {
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

- (ICCollege *)collegeAtIndex:(NSUInteger)index {
    return [self.array objectAtIndex:index];
}

@end
