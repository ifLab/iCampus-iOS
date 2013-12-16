//
//  ICSchoolBusList.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICSchoolBus;

@interface ICSchoolBusList : NSObject <NSFastEnumeration>

@property (nonatomic)       NSUInteger  index      ;
@property (nonatomic, copy) NSString   *name       ;
@property (nonatomic, copy) NSString   *description;

- (void)addBus:(ICSchoolBus *)bus;
- (void)addBusFromBusList:(ICSchoolBusList *)busList;
- (void)removeBus:(ICSchoolBus *)bus;
- (NSUInteger)count;
- (ICSchoolBus *)firstBus;
- (ICSchoolBus *)lastBus;
- (ICSchoolBus *)busAtIndex:(NSUInteger)index;

@end
