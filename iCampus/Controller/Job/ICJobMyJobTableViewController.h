//
//  ICJobMyJobTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-5-24.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICJobMyJobTableViewControllerDelegate <NSObject>

- (void)tellICJobListTableViewControllerNeedReloadData;

@end

@interface ICJobMyJobTableViewController : UITableViewController

@property (weak, nonatomic) id <ICJobMyJobTableViewControllerDelegate> delegate;

@end
