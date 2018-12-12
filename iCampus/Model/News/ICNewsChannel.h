//
//  ICNewsChannel.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ICNewsChannel : NSObject

//@property (nonatomic)       NSUInteger  index            ;
//@property (nonatomic, copy) NSString   *title            ;
//@property (nonatomic, copy) NSDate     *lastUpdateDate   ;
//@property (nonatomic, copy) NSString   *listKey          ;

@property (nonatomic, strong) NSNumber *chnldoccount;
@property (nonatomic, copy)   NSString *chnlid;
@property (nonatomic, copy)   NSString *chnlname;
@property (nonatomic, copy)   NSString *chnlurl;


+ (void)getChannelWithSuccess:(void (^)(NSArray<ICNewsChannel *> * channels))success failure:(void (^)(NSError *error))failure;

@end
