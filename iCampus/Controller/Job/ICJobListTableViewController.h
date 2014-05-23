//
//  ICJobListTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "../../Model/Job/ICJobList.h"
#import "../../Model/Job/ICJobClassificationList.h"
#import "ICJobDetailTableViewController.h"
#import "ICJobClassificationListTableViewController.h"

@interface ICJobListTableViewController : UITableViewController <ICJobClassificationListTableViewControllerDelegate, ICJobDetailTableViewControllerDelegate>

- (void)changeClassificationWith:(ICJobClassification*)classification;
- (void)appearSegmentedControl;

@end
