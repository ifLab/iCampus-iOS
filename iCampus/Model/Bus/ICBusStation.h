//
//  ICBusStation.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICBusStation : NSObject

@property (nonatomic)       NSUInteger  index;
@property (nonatomic, copy) NSString   *name ;
@property (nonatomic, copy) NSDate     *time ;

@end

#import "ICBusStationList.h"