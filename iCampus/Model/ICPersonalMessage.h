//
//  ICPersonalMessage.h
//  iCampus
//
//  Created by xlx on 15/5/26.
//  Copyright (c) 2015年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PersonalMessageProtocol <NSObject>

- (void)loadPersonalMessage;

@end
@interface ICPersonalMessage : NSObject
-(void)receivedPersonnalDetial;
@property (nonatomic,strong) NSString                *userid;
@property (nonatomic,strong) NSArray                 *message;
@property (nonatomic,strong) NSString                *name;
//

@property (weak, nonatomic ) id <PersonalMessageProtocol> delegate;
@end
