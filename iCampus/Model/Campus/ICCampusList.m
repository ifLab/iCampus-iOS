//
//  ICCampusList.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-12-3.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICCampusList.h"
#import "ICCampus.h"
#import "../ICModuleConfig.h"

@interface ICCampusList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICCampusList

+ (ICCampusList *)campusList {
    ICCampusList *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=map", ICCampusServerDomain];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_CAMPUS_MODULE_DEBUG__)
            NSLog(@"%@ %@ %@", ICCampusTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef __IC_CAMPUS_MODULE_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICCampusTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return instance;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_CAMPUS_MODULE_DEBUG__)
            NSLog(@"%@ %@ %@", ICCampusTag, ICSucceededTag, urlString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        for (NSDictionary *a in json) {
            ICCampus *campus = [[ICCampus alloc] init];
            campus.index = [[a objectForKey:@"id"] intValue];
            campus.name = [a objectForKey:@"areaName"];
            campus.address = [a objectForKey:@"areaAddress"];
            campus.zipCode = [[a objectForKey:@"zipCode"] intValue];
            campus.longitude = [[a objectForKey:@"longitude"] floatValue];
            campus.latitude = [[a objectForKey:@"latitude"] floatValue];
            campus.zoom = [[a objectForKey:@"zoom"] floatValue];
            [instance addCampus:campus];
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

- (void)addCampus:(ICCampus *)campus {
    [self.array addObject:campus];
}

- (void)addCampusFromCampusList:(ICCampusList *)campusList {
    [self.array addObjectsFromArray:campusList.array];
}

- (void)removeCampus:(ICCampus *)campus {
    [self.array removeObject:campus];
}

- (ICCampus *)firstCampus {
    return self.array.firstObject;
}

- (ICCampus *)lastCampus {
    return self.array.lastObject;
}

- (NSUInteger)count {
    return self.array.count;
}

- (ICCampus *)campusAtIndex:(NSUInteger)index {
    return [self.array objectAtIndex:index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state
                                           objects:buffer
                                             count:len];
}

@end
