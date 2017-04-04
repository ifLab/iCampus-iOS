//
//  ICNewsChannel.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ICNewsChannel : NSObject

@property (nonatomic)       NSUInteger  index            ;
@property (nonatomic, copy) NSString   *title            ;
@property (nonatomic, copy) NSDate     *lastUpdateDate   ;
@property (nonatomic, copy) NSString   *listKey          ;
@end
