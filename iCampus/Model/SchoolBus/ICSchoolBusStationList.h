//
//  ICSchoolBusStationList.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICSchoolBusStation;

@interface ICSchoolBusStationList : NSObject <NSFastEnumeration>

- (void)addStation:(ICSchoolBusStation *)station;
- (void)addStationFromStationList:(ICSchoolBusStationList *)stationList;
- (void)removeStation:(ICSchoolBusStation *)station;
- (NSUInteger)count;
- (ICSchoolBusStation *)firstStation;
- (ICSchoolBusStation *)lastStation;
- (ICSchoolBusStation *)stationAtIndex:(NSUInteger)index;

@end
