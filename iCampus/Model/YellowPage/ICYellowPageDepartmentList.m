//
//  ICYellowPageDepartmentList.m
//  iCampus
//
//  Created by Darren Liu on 14-1-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "../ICModelConfig.h"
#import "ICYellowPageDepartment.h"
#import "ICYellowPageDepartmentList.h"

@interface ICYellowPageDepartmentList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICYellowPageDepartmentList

+ (ICYellowPageDepartmentList *)departmentList {
    ICYellowPageDepartmentList *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/newapi/yellowpage.php?action=cat", ICYellowPageServerDomain];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_YELLOWPAGE_MODULE_DEPARTMENT_DEBUG__)
        NSLog(@"%@ %@ %@", ICYellowPageDepartmentTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef __IC_YELLOWPAGE_MODULE_DEPARTMENT_DEBUG__
            NSLog(@"%@ %@ %@ %@", ICYellowPageDepartmentTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return instance;
        }
        NSString *dataString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n"
                                                           withString:@""];
        if ([dataString characterAtIndex:0] != '[' && [dataString characterAtIndex:0] != '{') {
#           ifdef __IC_YELLOWPAGE_MODULE_DEPARTMENT_DEBUG__
            NSLog(@"%@ %@ %@ %@", ICYellowPageDepartmentTag, ICFailedTag, ICBrokenTag, urlString);
#           endif
            return instance;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_YELLOWPAGE_MODULE_DEPARTMENT_DEBUG__)
        NSLog(@"%@ %@ %@", ICYellowPageDepartmentTag, ICSucceededTag, urlString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        for (NSDictionary *a in json) {
            ICYellowPageDepartment *department = [[ICYellowPageDepartment alloc] init];
            department.index           = [[a objectForKey:@"id"] intValue];
            department.name            = [a objectForKey:@"name"];
            department.departmentIndex = [[a objectForKey:@"depart"] intValue];
            [instance addDepartment:department];
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

- (void)addDepartment:(ICYellowPageDepartment *)department {
    [self.array addObject:department];
}

- (void)addDepartmentsFromDepartmentList:(ICYellowPageDepartmentList *)departmentList {
    [self.array addObjectsFromArray:departmentList.array];
}

- (void)removeDepartment:(ICYellowPageDepartment *)department {
    [self.array removeObject:department];
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

- (ICYellowPageDepartment *)firstDepartment {
    return self.array.firstObject;
}

- (ICYellowPageDepartment *)lastDepartment {
    return self.array.lastObject;
}

- (ICYellowPageDepartment *)departmentAtIndex:(NSUInteger)index {
    return [self.array objectAtIndex:index];
}

@end
