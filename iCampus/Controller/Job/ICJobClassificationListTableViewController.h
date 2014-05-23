//
//  ICJobClassificationListTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-4-20.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "../../Model/Job/ICJobClassificationList.h"

@protocol ICJobClassificationListTableViewControllerDelegate <NSObject>

- (void)changeClassificationWith:(ICJobClassification*)classification;

@end

@interface ICJobClassificationListTableViewController : UITableViewController

@property (weak, nonatomic) id <ICJobClassificationListTableViewControllerDelegate> delegate;

@end
