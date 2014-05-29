//
//  ICJobDetailTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-4-15.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../Model/Job/ICJob.h"
#import "../../Model/Job/ICJobClassification.h"
#import "../../Model/Job/ICJobFavoritesJobList.h"
#import "MBProgressHUD.h"

@protocol ICJobDetailTableViewControllerDelegate <NSObject>

- (void)appearSegmentedControl;

@end

@interface ICJobDetailTableViewController : UITableViewController

@property (weak, nonatomic) id <ICJobDetailTableViewControllerDelegate> delegate;
@property (strong, nonatomic) ICJob *job;
@property NSInteger jobID;
@property (strong, nonatomic) UIBarButtonItem *favoritesButton;
@property NSString *mode;

@end
