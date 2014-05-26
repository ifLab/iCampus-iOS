//
//  ICJobNewJobTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-4-1.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICUser.h"
#import "../../Model/Job/ICJobList.h"
#import "../../Model/Job/ICJobClassificationList.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@protocol ICJobNewJobTableViewControllerDelegate <NSObject>

- (void)needReloadData;

@end

@interface ICJobNewJobTableViewController : UITableViewController <UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id <ICJobNewJobTableViewControllerDelegate> delegate;

@end
