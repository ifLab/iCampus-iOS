//
//  ICCollegeDetail.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICCollege;

@interface ICCollegeDetail : NSObject

@property (nonatomic) NSUInteger      index;
@property (nonatomic, copy) NSString *mark ;
@property (nonatomic, copy) NSString *name ;
@property (nonatomic, copy) NSString *body ;
@property (nonatomic, copy) NSURL    *url  ;
@property (nonatomic) NSUInteger      rank ;

+ (ICCollegeDetail *)collegeDetailWithCollege:(ICCollege *)college;
- (id)initWithCollege:(ICCollege *)college;

@end
