//
//  ICNewsCatViewController.h
//  iCampus
//
//  Created by Kwei Ma on 13-11-14.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICNewsChannel, ICNewsCatViewController;

@protocol ICNewsCatDelegate <NSObject>

- (void)catViewController:(ICNewsCatViewController *)catVC didFinishSelectingCat:(ICNewsChannel *)channel;

@end

@interface ICNewsCatViewController : UITableViewController

@property (weak, nonatomic) id<ICNewsCatDelegate> delegate;

@end
