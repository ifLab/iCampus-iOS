//
//  ICYellowPageListViewController.h
//  iCampus
//
//  Created by Darren Liu on 13-12-25.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICYellowPageDepartment;

@interface ICYellowPageListViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) ICYellowPageDepartment *department;

@end
