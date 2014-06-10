//
//  ICJobListTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICJobClassificationListTableViewController.h"
#import "ICJobDetailTableViewController.h"
#import "ICJobMoreTableViewController.h"
#import "ICLoginViewController.h"

@interface ICJobListTableViewController : UITableViewController
<
ICJobClassificationListTableViewControllerDelegate,
ICJobMoreTableViewControllerDelegate,
ICLoginViewControllerDelegate
>
@end
