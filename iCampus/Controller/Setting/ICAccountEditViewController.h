//
//  ICAccountEditViewController.h
//  iCampus
//
//  Created by Darren Liu on 14-5-22.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICAccountEditViewController;

@protocol ICAccoutEditViewControllerDelegate <NSObject>

typedef enum {
    ICAccountEditViewControllerDismissStatusCancel = 0,
    ICAccountEditViewControllerDismissStatusDone = 1
} ICAccountEditViewControllerDismissStatus;

- (void)accountEditViewController:(ICAccountEditViewController *)accountEditViewController
             didDismissWithStatus:(ICAccountEditViewControllerDismissStatus)status;

@end

@interface ICAccountEditViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *QQDetailTextField;
@property (weak, nonatomic) IBOutlet UITextField *WeChatDetailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileDetailTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailDetailTextField;
@property (weak, nonatomic) id<ICAccoutEditViewControllerDelegate> delegate;

- (void)dismiss:(id)sender;

@end
