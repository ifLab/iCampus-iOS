//
//  ICYellowPage.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-11.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICYellowPageContact, ICYellowPageDepartment;

@interface ICYellowPage : NSObject <NSFastEnumeration>

+ (ICYellowPage *)yellowPageWithDepartment:(ICYellowPageDepartment *)department;
- (void)addContact:(ICYellowPageContact *)contact;
- (void)addContactFromYellowPage:(ICYellowPage *)yellowPage;
- (void)removeContact:(ICYellowPageContact *)contact;
- (NSUInteger)count;
- (ICYellowPageContact *)firstContact;
- (ICYellowPageContact *)lastContact;
- (ICYellowPageContact *)contactAtIndex:(NSUInteger)index;
- (ICYellowPage *)yellowPageSortedByPinyin;

@end

#import "ICYellowPageContact.h"
#import "ICYellowPageDepartment.h"
#import "ICYellowPageDepartmentList.h"