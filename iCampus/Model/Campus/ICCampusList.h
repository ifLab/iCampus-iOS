//
//  ICCampusList.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-12-3.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICCampus;

@interface ICCampusList : NSObject <NSFastEnumeration>

+ (ICCampusList *)campusList;
- (void)addCampus:(ICCampus *)campus;
- (void)addCampusFromCampusList:(ICCampusList *)campusList;
- (void)removeCampus:(ICCampus *)campus;
- (ICCampus *)firstCampus;
- (ICCampus *)lastCampus;
- (NSUInteger)count;
- (ICCampus *)campusAtIndex:(NSUInteger)index;

@end
