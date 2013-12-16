//
//  ICCollegeList.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICCollege;

@interface ICCollegeList : NSObject <NSFastEnumeration>

+ (ICCollegeList *)collegeList;
- (void)addCollege:(ICCollege *)college;
- (void)addCollegeFromCollegeList:(ICCollegeList *)collegeList;
- (void)removeCollege:(ICCollege *)college;
- (ICCollege *)firstCollege;
- (ICCollege *)lastCollege;
- (NSUInteger)count;
- (ICCollege *)collegeAtIndex:(NSUInteger)index;

@end
