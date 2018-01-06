//
//  PJNewLostViewController.h
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJZoomImageScrollView.h"

@interface PJNewLostViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet PJZoomImageScrollView *imgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *detailsTextViewLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTextFieldTipsLabel;

@end
