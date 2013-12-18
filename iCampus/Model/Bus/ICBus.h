//
//  ICBus.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICBusStationList;

@interface ICBus : NSObject

@property (nonatomic)         NSUInteger       index        ;
@property (nonatomic, copy)   NSString         *name         ;
@property (nonatomic, copy)   NSString         *description  ;
@property (nonatomic, copy)   NSDate           *departureTime;
@property (nonatomic, copy)   NSDate           *returnTime   ;
@property (nonatomic, strong) ICBusStationList *stationList  ;

@end

#import "ICBusList.h"
#import "ICBusListArray.h"
#import "ICBusStation.h"
#import "ICBusStationList.h"
