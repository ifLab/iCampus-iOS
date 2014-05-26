//
//  ICJobListTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICUser.h"
#import "../../Model/Job/ICJobList.h"
#import "../../Model/Job/ICJobClassificationList.h"
#import "ICJobDetailTableViewController.h"
#import "ICJobClassificationListTableViewController.h"
#import "ICJobMoreTableViewController.h"
#import "../Setting/ICLoginViewController.h"
#import "MBProgressHUD.h"

@interface ICJobListTableViewController : UITableViewController <ICJobClassificationListTableViewControllerDelegate, ICJobDetailTableViewControllerDelegate, ICJobMoreTableViewControllerDelegate, ICLoginViewControllerDelegate>

@end
