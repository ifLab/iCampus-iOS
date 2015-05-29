//
//  ICGroup.h
//  iCampus
//
//  Created by xlx on 15/5/26.
//  Copyright (c) 2015年 BISTU. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol GroupProtocol <NSObject>

- (void)loadCompelect;

@end

@interface ICGroup : NSObject

- (void)receivedPersonnalMessage:(NSString *)    PersonalID;
@property (nonatomic,strong) NSString            *title;
@property (nonatomic,strong) NSDictionary        *message;
@property (weak, nonatomic ) id <GroupProtocol > delegate;
/**
 *  个人信息
 */
@property (nonatomic,strong) NSMutableArray *group;
@property (nonatomic,strong) NSMutableArray *userid;
@property (nonatomic,strong) NSMutableArray *type;
@property (nonatomic,strong) NSMutableArray *groupid;
//
@end
