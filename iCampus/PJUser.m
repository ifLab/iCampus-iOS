//
//  orWorkerUser.m
//  usCRM
//
//  Created by xlx on 16/8/30.
//  Copyright © 2016年 xlx. All rights reserved.
//

#import "PJUser.h"
#import "MJExtension.h"

@implementation PJUser
MJExtensionCodingImplementation

+(PJUser *)currentUser{
    PJUser *user;
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/user.data"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        user = nil;
    }else{
        user = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    }
    return user;
}

-(void)save{
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/user.data"];
    // Encoding
    [NSKeyedArchiver archiveRootObject:self toFile:file];
}

+(void)logOut{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/user.data"];
    [manager removeItemAtPath:filePath error:nil];
}
@end
