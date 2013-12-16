//
//  ICYellowPageContact.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-11.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICYellowPageContact : NSObject

@property (nonatomic)       NSUInteger  index          ;
@property (nonatomic, copy) NSString   *name           ;
@property (nonatomic, copy) NSString   *telephone      ;
@property (nonatomic)       NSUInteger  departmentIndex;

@end
