//
//  ICJobClassificationList.h
//  iCampus
//
//  Created by Jerry Black on 14-4-20.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICJobClassification.h"

@interface ICJobClassificationList : NSObject

@property (nonatomic, strong) NSMutableArray *jobClassificationList;

+ (id)loadJobClassificationList;

@end
