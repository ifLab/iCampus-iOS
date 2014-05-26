//
//  ICJobMoreTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-4-13.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICJobMyJobTableViewController.h"

@protocol ICJobMoreTableViewControllerDelegate <NSObject>

- (void)needReloadData;

@end

@interface ICJobMoreTableViewController : UITableViewController <ICJobMyJobTableViewControllerDelegate>

@property (weak, nonatomic) id <ICJobMoreTableViewControllerDelegate> delegate;

@end
