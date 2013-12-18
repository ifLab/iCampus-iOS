//
//  ICBusListArray.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-12-3.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICBusList;

@interface ICBusListArray : NSObject <NSFastEnumeration>

+ (ICBusListArray *)array;
- (void)addBusList:(ICBusList *)busList;
- (void)addBusListFromArray:(ICBusListArray *)array;
- (void)removeBusList:(ICBusList *)list;
- (NSUInteger)count;
- (ICBusList *)firstBusList;
- (ICBusList *)lastBusList;
- (ICBusList *)BusListAtIndex:(NSUInteger)index;

@end
