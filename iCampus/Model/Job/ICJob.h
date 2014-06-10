//
//  ICJob.h
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICJob : NSObject

@property (nonatomic)       NSUInteger  index         ;
@property (nonatomic, copy) NSString   *title         ;
@property (nonatomic, copy) NSString   *description   ;
@property (nonatomic, copy) NSString   *location      ;
@property (nonatomic, copy) NSString   *qualifications;
@property (nonatomic, copy) NSString   *salary        ;
@property (nonatomic, copy) NSString   *contactName   ;
@property (nonatomic, copy) NSString   *contactEmail  ;
@property (nonatomic, copy) NSString   *contactPhone  ;
@property (nonatomic, copy) NSString   *contactQQ     ;
@property (nonatomic, copy) NSString   *company       ;
@property (nonatomic, copy) NSString   *promulgatorID ;

+ (id)loadJobDetailWith:(NSInteger)jobID;

@end

#import "ICJobList.h"
#import "ICJobClassification.h"
#import "ICJobClassificationList.h"
#import "ICJobFavoritesJobList.h"
