//
//  ICNewsListViewController.h
//  iCampus
//
//  Created by Kwei Ma on 13-11-6.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICNewsChannel, ICNewsList;

@interface ICNewsListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ICNewsChannel *channel ;
@property (strong, nonatomic) ICNewsList    *newsList;

- (IBAction)dismiss:(id)sender;

@end
