//
//  ICJobFavoritesJobList.h
//  iCampus
//
//  Created by Jerry Black on 14-5-28.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICJob;

@interface ICJobFavoritesJobList : NSObject

@property (nonatomic, strong) NSMutableArray *favoritesList;

+ (id)loadData;
+ (BOOL)addJob:(ICJob*)job;
+ (BOOL)deleteJob:(ICJob*)job;
+ (BOOL)checkJob:(ICJob*)job;

@end
