//
//  ICBusList.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICBusList.h"
#import "ICBus.h"
#import "ICBusStation.h"

@interface ICBusList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICBusList

- (id)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (void)addBus:(ICBus *)bus {
    [self.array addObject:bus];
}

- (void)addBusFromBusList:(ICBusList *)busList {
    [self.array addObjectsFromArray:busList.array];
}

- (void)removeBus:(ICBus *)bus {
    [self.array removeObject:bus];
}

- (NSUInteger)count {
    return [self.array count];
}

- (ICBus *)firstBus {
    return self.array.firstObject;
}

- (ICBus *)lastBus {
    return self.array.lastObject;
}

- (ICBus *)busAtIndex:(NSUInteger)index {
    return (self.array)[index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state
                                           objects:buffer
                                             count:len];
}

@end
