//
//  ICCampus.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-12-3.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICCampus : NSObject

@property (nonatomic)       NSUInteger  index    ;
@property (nonatomic, copy) NSString   *name     ;
@property (nonatomic, copy) NSString   *address  ;
@property (nonatomic)       NSUInteger  zipCode  ;
@property (nonatomic)       CGFloat     longitude;
@property (nonatomic)       CGFloat     latitude ;
@property (nonatomic)       CGFloat     zoom     ;

@end

#import "ICCampusList.h"
