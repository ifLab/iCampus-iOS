//
//  ICNewsCatViewController.h
//  iCampus
//
//  Created by Kwei Ma on 13-11-14.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICNewsChannel, ICNewsChannelViewController;

@protocol ICNewsChannelDelegate <NSObject>

- (void)newsChannelViewController:(ICNewsChannelViewController *)controller
        didFinishSelectingChannel:(ICNewsChannel *)channel;

@end

@interface ICNewsChannelViewController : UITableViewController

@property (weak, nonatomic) id <ICNewsChannelDelegate> delegate;

@end
