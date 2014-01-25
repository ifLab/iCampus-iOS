//
//  ICYellowPageDepartmentList.h
//  iCampus
//
//  Created by Darren Liu on 14-1-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICYellowPageDepartment;

@interface ICYellowPageDepartmentList : UITableViewController <NSFastEnumeration>

+ (ICYellowPageDepartmentList *)departmentList;
- (void)addDepartment:(ICYellowPageDepartment *)department;
- (void)addDepartmentsFromDepartmentList:(ICYellowPageDepartmentList *)departmentList;
- (void)removeDepartment:(ICYellowPageDepartment *)department;
- (NSUInteger)count;
- (ICYellowPageDepartment *)firstDepartment;
- (ICYellowPageDepartment *)lastDepartment;
- (ICYellowPageDepartment *)departmentAtIndex:(NSUInteger)index;

@end
