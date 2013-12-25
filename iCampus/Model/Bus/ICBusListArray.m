//
//  ICBusListArray.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-12-3.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICBusListArray.h"
#import "ICBusList.h"
#import "ICBusStation.h"
#import "ICBus.h"
#import "../ICModelConfig.h"

@interface ICBusListArray ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICBusListArray

+ (ICBusListArray *)array {
    ICBusListArray *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/newapi/bus.php", ICBusServerDomain];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_BUS_MODULE_DEBUG__)
            NSLog(@"%@ %@ %@", ICBusTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
            return instance;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        if (!json) {
#           ifdef __IC_BUS_MODULE_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICBusTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return instance;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_BUS_MODULE_DEBUG__)
            NSLog(@"%@ %@ %@", ICBusTag, ICSucceededTag, urlString);
#       endif
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:(NSString *)ICTimeZoneName];
        for (NSDictionary __strong *a in json) {
            ICBusList *busList = [[ICBusList alloc] init];
            busList.index = [[a objectForKey:@"id"] intValue];
            busList.name = [a objectForKey:@"catName"];
            busList.description = [a objectForKey:@"catIntro"];
            a = [a objectForKey:@"catBus"];
            for (NSDictionary *b in a) {
                NSArray *c = [b objectForKey:@"busLine"];
                dateFormatter.dateFormat = @"HH:mm";
                ICBusStationList *stationList = [[ICBusStationList alloc] init];
                for (NSDictionary *d in c) {
                    for (NSString *e in d) {
                        ICBusStation *station = [[ICBusStation alloc] init];
                        station.name = e;
                        station.time = [dateFormatter dateFromString:[d objectForKey:e]];
                        [stationList addStation:station];
                    }
                }
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                id returnTime = [b objectForKey:@"returnTime"];
                if ([returnTime isEqual:[NSNull null]]) {
                    returnTime = nil;
                } else {
                    returnTime = [dateFormatter dateFromString:[NSString stringWithString:returnTime]];
                }
                NSLog(@"%@", returnTime);
                ICBus *bus = [[ICBus alloc] init];
                bus.index = [[b objectForKey:@"id"] intValue];
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

- (void)addBusList:(ICBusList *)busList {
    [self.array addObject:busList];
}

- (void)addBusListFromArray:(ICBusListArray *)array {
    [self.array addObjectsFromArray:array.array];
}

- (void)removeBusList:(ICBusList *)list {
    [self.array removeObject:list];
}

- (NSUInteger)count {
    return self.array.count;
}

- (ICBusList *)firstBusList {
    return self.array.firstObject;
}

- (ICBusList *)lastBusList {
    return self.array.lastObject;
}

- (ICBusList *)busListAtIndex:(NSUInteger)index {
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
