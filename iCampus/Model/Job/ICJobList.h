//
//  ICJobList.h
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICJob.h"
#import "ICJobClassification.h"

@class ICJob, ICJobChannel;

@interface ICJobList : NSObject

@property (nonatomic, strong) NSMutableArray *jobList;

+ (id)loadJobListWithType:(BOOL)type
             classification:(ICJobClassification*)classification;

+ (id)loadJobListWithID:(NSString*)userID;

@end
