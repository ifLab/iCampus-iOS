//
//  ICSchoolBusStationList.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICSchoolBusStationList.h"
#import "ICSchoolBusStation.h"

@interface ICSchoolBusStationList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICSchoolBusStationList

- (id)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (void)addStation:(ICSchoolBusStation *)station {
    [self.array addObject:station];
}

- (void)addStationFromStationList:(ICSchoolBusStationList *)stationList {
    [self.array addObjectsFromArray:stationList.array];
}

- (void)removeStation:(ICSchoolBusStation *)station {
    [self.array removeObject:station];
}

- (NSUInteger)count {
    return [self.array count];
}

- (ICSchoolBusStation *)firstStation {
    return self.array.firstObject;
}

- (ICSchoolBusStation *)lastStation {
    return self.array.lastObject;
}

- (ICSchoolBusStation *)stationAtIndex:(NSUInteger)index {
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
