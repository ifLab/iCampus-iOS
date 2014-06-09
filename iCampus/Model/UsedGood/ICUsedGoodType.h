//
//  ICUsedGoodType.h
//  iCampus
//
//  Created by EricLee on 14-6-2.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICUsedGoodType : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;

+ (NSArray *)typeList;

@end
