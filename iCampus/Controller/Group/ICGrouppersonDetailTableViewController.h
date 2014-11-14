//
//  ICGrouppersonDetailTableViewController.h
//  iCampus
//
//  Created by Rex Ma on 14-5-23.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICGrouppersonDetailTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSDictionary *detailItem;
@end
