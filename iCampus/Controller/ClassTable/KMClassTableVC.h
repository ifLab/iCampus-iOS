//
//  KMClassTableVC.h
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-8-23.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMClassTableVC : UIViewController

- (IBAction)dismiss:(id)sender;

@end

#define kLeftScrollViewTag 8301
#define kTopScrollViewTag 8302
#define kCenterScrollViewTag 8300

const CGFloat cellWidth = 59.0f;
const CGFloat cellHeight = 60.0f;
const CGFloat columnWidth = 20.0f;