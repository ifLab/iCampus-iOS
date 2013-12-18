//
//  ICBusList.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-15.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICBus;

@interface ICBusList : NSObject <NSFastEnumeration>

@property (nonatomic)       NSUInteger  index      ;
@property (nonatomic, copy) NSString   *name       ;
@property (nonatomic, copy) NSString   *description;

- (void)addBus:(ICBus *)bus;
- (void)addBusFromBusList:(ICBusList *)busList;
- (void)removeBus:(ICBus *)bus;
- (NSUInteger)count;
- (ICBus *)firstBus;
- (ICBus *)lastBus;
- (ICBus *)busAtIndex:(NSUInteger)index;

@end
