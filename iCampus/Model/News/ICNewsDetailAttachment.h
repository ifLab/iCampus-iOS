//
//  ICNewsDetailAttachment.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-6.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICNewsDetailAttachment : NSObject

@property (nonatomic, copy) NSString   *name;
@property (nonatomic, copy) NSURL      *url ;
@property (nonatomic)       NSUInteger  type;

@end
