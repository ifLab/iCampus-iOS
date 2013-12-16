//
//  ICSchoolBusList.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICSchoolBusList.h"
#import "ICSchoolBus.h"
#import "ICSchoolBusStation.h"

@interface ICSchoolBusList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICSchoolBusList

- (id)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (void)addBus:(ICSchoolBus *)bus {
    [self.array addObject:bus];
}

- (void)addBusFromBusList:(ICSchoolBusList *)busList {
    [self.array addObjectsFromArray:busList.array];
}

- (void)removeBus:(ICSchoolBus *)bus {
    [self.array removeObject:bus];
}

- (NSUInteger)count {
    return [self.array count];
}

- (ICSchoolBus *)firstBus {
    return self.array.firstObject;
}

- (ICSchoolBus *)lastBus {
    return self.array.lastObject;
}

- (ICSchoolBus *)busAtIndex:(NSUInteger)index {
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
