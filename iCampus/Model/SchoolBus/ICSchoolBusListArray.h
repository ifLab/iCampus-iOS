//
//  ICSchoolBusListArray.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-12-3.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICSchoolBusList;

@interface ICSchoolBusListArray : NSObject <NSFastEnumeration>

+ (ICSchoolBusListArray *)array;
- (void)addBusList:(ICSchoolBusList *)busList;
- (void)addBusListFromArray:(ICSchoolBusListArray *)array;
- (void)removeBusList:(ICSchoolBusList *)list;
- (NSUInteger)count;
- (ICSchoolBusList *)firstBusList;
- (ICSchoolBusList *)lastBusList;
- (ICSchoolBusList *)schoolBusListAtIndex:(NSUInteger)index;

@end
