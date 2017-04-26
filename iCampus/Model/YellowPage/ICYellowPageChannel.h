//
//  ICYellowPageChannel.h
//  iCampus
//
//  Created by Bill Hu on 2017/4/22.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICYellowPageChannel : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *department;

+(void)fetchYellowPageChannel:(void(^)(NSArray*))success
                      failure:(void(^)(NSString*))failure;

@end
