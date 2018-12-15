//
//  BlogModel.h
//  iCampus
//
//  Created by 徐正科 on 2018/12/15.
//  Copyright © 2018 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MasUser;

NS_ASSUME_NONNULL_BEGIN

@interface BlogModel : NSObject

@property (nonatomic, copy) NSString *masuser_id;
@property (nonatomic, copy) NSString *last_updated_time;
@property (nonatomic, assign) NSInteger read_num;
@property (nonatomic, strong) MasUser *masuser;
@property (nonatomic, assign) NSInteger blog_id;
@property (nonatomic, copy) NSString *created_time;
@property (nonatomic, copy) NSString *content;

+ (void)getBlogsWithPage:(NSInteger)page success:(void(^)(NSArray<BlogModel *> *data))success failure:(void(^)(NSString *err))failure;

@end

NS_ASSUME_NONNULL_END
