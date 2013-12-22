//
//  ICSchoolList.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICSchool;

@interface ICSchoolList : NSObject <NSFastEnumeration>

+ (ICSchoolList *)schoolList;
- (void)addSchool:(ICSchool *)school;
- (void)addSchoolFromSchoolList:(ICSchoolList *)schoolList;
- (void)removeSchool:(ICSchool *)school;
- (ICSchool *)firstSchool;
- (ICSchool *)lastSchool;
- (NSUInteger)count;
- (ICSchool *)schoolAtIndex:(NSUInteger)index;

@end
