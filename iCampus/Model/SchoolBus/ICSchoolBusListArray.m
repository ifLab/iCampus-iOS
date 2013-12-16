//
//  ICSchoolBusListArray.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-12-3.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICSchoolBusListArray.h"
#import "ICSchoolBusList.h"
#import "ICSchoolBusStation.h"
#import "ICSchoolBus.h"
#import "../ICModuleConfig.h"

@interface ICSchoolBusListArray ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICSchoolBusListArray

+ (ICSchoolBusListArray *)array {
    ICSchoolBusListArray *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/newapi/bus.php", ICSchoolBusServerDomain];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_SCHOOLBUS_MODULE_DEBUG__)
            NSLog(@"%@ %@ %@", ICSchoolBusTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        if (!json) {
#           ifdef __IC_SCHOOLBUS_MODULE_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICSchoolBusTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return instance;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_SCHOOLBUS_MODULE_DEBUG__)
            NSLog(@"%@ %@ %@", ICSchoolBusTag, ICSucceededTag, urlString);
#       endif
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:(NSString *)ICTimeZoneName]];
        for (__strong NSDictionary *a in json) {
            ICSchoolBusList *busList = [[ICSchoolBusList alloc] init];
            busList.index = [[a objectForKey:@"id"] intValue];
            busList.name = [a objectForKey:@"catName"];
            busList.description = [a objectForKey:@"catIntro"];
            a = [a objectForKey:@"catBus"];
            for (NSDictionary *b in a) {
                NSArray *c = [b objectForKey:@"busLine"];
                [dateFormatter setDateFormat:@"hh:mm"];
                ICSchoolBusStationList *stationList = [[ICSchoolBusStationList alloc] init];
                for (NSDictionary *d in c) {
                    for (NSString *e in d) {
                        ICSchoolBusStation *station = [[ICSchoolBusStation alloc] init];
                        station.name = e;
                        station.time = [dateFormatter dateFromString:[d objectForKey:e]];
                        [stationList addStation:station];
                    }
                }
                [dateFormatter setDateFormat:@"hh:mm:ss"];
                NSObject *returnTime = [b objectForKey:@"returnTime"];
                if ([returnTime isEqual:[NSNull null]]) {
                    returnTime = nil;
                } else {
                    returnTime = [dateFormatter dateFromString:(NSString *)returnTime];
                }
                ICSchoolBus *bus = [[ICSchoolBus alloc] init];
                bus.index = [[b objectForKey:@"busCat"] intValue];
                bus.name = [b objectForKey:@"busName"];
                bus.description = [b objectForKey:@"busIntro"];
                bus.departureTime = [dateFormatter dateFromString:[b objectForKey:@"departTime"]];
                bus.returnTime = (NSDate *)returnTime;
                bus.stationList = stationList;
                [busList addBus:bus];
            }
            [instance addBusList:busList];
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

- (void)addBusList:(ICSchoolBusList *)busList {
    [self.array addObject:busList];
}

- (void)addBusListFromArray:(ICSchoolBusListArray *)array {
    [self.array addObjectsFromArray:array.array];
}

- (void)removeBusList:(ICSchoolBusList *)list {
    [self.array removeObject:list];
}

- (NSUInteger)count {
    return self.array.count;
}

- (ICSchoolBusList *)firstBusList {
    return self.array.firstObject;
}

- (ICSchoolBusList *)lastBusList {
    return self.array.lastObject;
}

- (ICSchoolBusList *)schoolBusListAtIndex:(NSUInteger)index {
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
