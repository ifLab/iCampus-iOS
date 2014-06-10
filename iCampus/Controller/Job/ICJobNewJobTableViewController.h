//
//  ICJobNewJobTableViewController.h
//  iCampus
//
//  Created by Jerry Black on 14-4-1.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICJobNewJobTableViewControllerDelegate <NSObject>

- (void)needReloadData;

@end

@interface ICJobNewJobTableViewController : UITableViewController <UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id <ICJobNewJobTableViewControllerDelegate> delegate;

@end
