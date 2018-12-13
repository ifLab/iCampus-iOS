//
//  UserModel.h
//  iCampus
//
//  Created by xzk on 2018/11/29.
//  Copyright © 2018年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 头像
 */

@interface Avatar: NSObject

@property(nonatomic, copy)NSString *avatar_image;
@property(nonatomic, copy)NSString *avatar_color;

@end


/**
 * 用户
 */

@interface MasUser : NSObject

@property(nonatomic, copy)NSString *uid;
@property(nonatomic, strong)Avatar *avatar;
@property(nonatomic, copy)NSString *work_mes;
@property(nonatomic, copy)NSString *travel_mes;
@property(nonatomic, copy)NSString *slogan;
@property(nonatomic, copy)NSString *interest_mes;
@property(nonatomic, copy)NSString *nick_name;
@property(nonatomic, copy)NSString *created_time;

@end

/**
 * Model
 */
@interface UserModel : NSObject

@property(nonatomic, strong)MasUser *masuser;
@property(nonatomic, copy)NSString *token;

+ (instancetype)user;
+ (BOOL)isLogin;
+ (BOOL)CASCertified;
+ (void)updateUserInfo:(NSDictionary *)dict success:(void (^)(void))success fialure:(void (^)(NSString *error))failure;
+ (void)logout;
// 存储登录信息
- (void)loginSuccess;
- (void)update;

@end

NS_ASSUME_NONNULL_END
