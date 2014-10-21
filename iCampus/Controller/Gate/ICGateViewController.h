//
//  ICViewController.h
//  iCampus
//
//  Created by Kwei Ma on 13-11-6.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMPageMenuViewController.h"

@interface ICGateViewController : KMPageMenuViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *messageButton;

- (IBAction)checkMessage:(id)sender;

@end
