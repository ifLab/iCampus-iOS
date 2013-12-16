//
//  ICSchoolBus.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICSchoolBusStationList;

@interface ICSchoolBus : NSObject

@property (nonatomic)         NSUInteger              index        ;
@property (nonatomic, copy)   NSString               *name         ;
@property (nonatomic, copy)   NSString               *description  ;
@property (nonatomic, copy)   NSDate                 *departureTime;
@property (nonatomic, copy)   NSDate                 *returnTime   ;
@property (nonatomic, strong) ICSchoolBusStationList *stationList  ;

@end

#import "ICSchoolBusList.h"
#import "ICSchoolBusListArray.h"
#import "ICSchoolBusStation.h"
#import "ICSchoolBusStationList.h"
