//
//  ICYellowPage.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-11.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICYellowPageContact;

@interface ICYellowPage : NSObject <NSFastEnumeration>

+ (ICYellowPage *)yellowPage;
- (void)addContact:(ICYellowPageContact *)contact;
- (void)addContactFromYellowPage:(ICYellowPage *)yellowPage;
- (void)removeContact:(ICYellowPageContact *)contact;
- (NSUInteger)count;
- (ICYellowPageContact *)firstContact;
- (ICYellowPageContact *)lastContact;
- (ICYellowPageContact *)contactAtIndex:(NSUInteger)index;

@end


#import "ICYellowPageContact.h"