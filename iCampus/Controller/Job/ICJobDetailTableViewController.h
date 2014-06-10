//
//  ICJobDetailTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-4-15.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICJob;

@interface ICJobDetailTableViewController : UITableViewController

@property (strong, nonatomic) ICJob *job;
@property NSInteger jobID;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoritesButton;
@property NSString *mode;

@end
