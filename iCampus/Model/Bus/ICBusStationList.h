//
//  ICBusStationList.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICBusStation;

@interface ICBusStationList : NSObject <NSFastEnumeration>

- (void)addStation:(ICBusStation *)station;
- (void)addStationFromStationList:(ICBusStationList *)stationList;
- (void)removeStation:(ICBusStation *)station;
- (NSUInteger)count;
- (ICBusStation *)firstStation;
- (ICBusStation *)lastStation;
- (ICBusStation *)stationAtIndex:(NSUInteger)index;

@end
