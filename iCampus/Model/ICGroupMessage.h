//
//  ICGroupMessage.h
//  iCampus
//
//  Created by xlx on 15/5/26.
//  Copyright (c) 2015年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GroupMessageProtocol <NSObject>

- (void)loadCompelectMessage;

@end
@interface ICGroupMessage : NSObject
@property NSInteger *select ;
-(void)receivedPersonnalMessage;
/**
 *  个人信息
 */
@property (nonatomic,strong) NSString             *group;
@property (nonatomic,strong) NSString             *userid;
@property (nonatomic,strong) NSString             *type;
@property (nonatomic,strong) NSString             *groupid;
//
/**
 *  全班信息
 */
@property (nonatomic,strong) NSArray              *message;
//
@property (weak, nonatomic ) id <GroupMessageProtocol> delegate;
@end
