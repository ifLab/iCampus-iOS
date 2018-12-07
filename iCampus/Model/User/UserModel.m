//
//  UserModel.m
//  iCampus
//
//  Created by xzk on 2018/11/29.
//  Copyright © 2018年 ifLab. All rights reserved.
//

#import "UserModel.h"

@interface Avatar()<NSCoding>

@end

@implementation Avatar

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.avatar_color = [aDecoder decodeObjectForKey:@"avatar_color"];
        self.avatar_image = [aDecoder decodeObjectForKey:@"avatar_image"];
    }
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.avatar_image forKey:@"avatar_image"];
    [aCoder encodeObject:self.avatar_color forKey:@"avatar_color"];
}


@end


@interface MasUser()<NSCoding>

@end

@implementation MasUser

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.work_mes = [aDecoder decodeObjectForKey:@"work_mes"];
        self.travel_mes = [aDecoder decodeObjectForKey:@"travel_mes"];
        self.slogan = [aDecoder decodeObjectForKey:@"slogan"];
        self.interest_mes = [aDecoder decodeObjectForKey:@"interest_mes"];
        self.nick_name = [aDecoder decodeObjectForKey:@"nick_name"];
        self.created_time = [aDecoder decodeObjectForKey:@"created_time"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.work_mes forKey:@"work_mes"];
    [aCoder encodeObject:self.travel_mes forKey:@"travel_mes"];
    [aCoder encodeObject:self.interest_mes forKey:@"interest_mes"];
    [aCoder encodeObject:self.nick_name forKey:@"nick_name"];
    [aCoder encodeObject:self.created_time forKey:@"created_time"];
    [aCoder encodeObject:self.slogan forKey:@"slogan"];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"avatar": @"Avatar"
             };
}
@end


@interface UserModel()<NSCoding>

@end

@implementation UserModel

+ (id)user {
    UserModel *user = nil;
    
    if (UserModel.isLogin) {
        user = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:UserModel.userPath];
    }
    
    return user;
}

+ (BOOL)isLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *res = [defaults objectForKey:kLoginSueecssUserDefaultKey];
    return res ? res.boolValue : NO;
}

+ (BOOL)CASCertified {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:kLoginCASCertifiedSuccessKey] boolValue] == YES;
}

+ (NSString *)userPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *userPath = [documentPath stringByAppendingPathComponent:@"user.data"];
    
    return userPath;
}

- (void)loginSuccess {
    
    [NSKeyedArchiver archiveRootObject:self toFile:UserModel.userPath];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(YES) forKey:kLoginSueecssUserDefaultKey];
    [defaults synchronize];
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"masuser": @"MasUser",
             };
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.masuser = [aDecoder decodeObjectForKey:@"masuser"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.masuser forKey:@"masuser"];
    [aCoder encodeObject:self.token forKey:@"token"];
}

@end

