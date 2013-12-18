//
//  ICBusStationList.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICBusStationList.h"
#import "ICBusStation.h"

@interface ICBusStationList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICBusStationList

- (id)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (void)addStation:(ICBusStation *)station {
    [self.array addObject:station];
}

- (void)addStationFromStationList:(ICBusStationList *)stationList {
    [self.array addObjectsFromArray:stationList.array];
}

- (void)removeStation:(ICBusStation *)station {
    [self.array removeObject:station];
}

- (NSUInteger)count {
    return [self.array count];
}

- (ICBusStation *)firstStation {
    return self.array.firstObject;
}

- (ICBusStation *)lastStation {
    return self.array.lastObject;
}

- (ICBusStation *)stationAtIndex:(NSUInteger)index {
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
