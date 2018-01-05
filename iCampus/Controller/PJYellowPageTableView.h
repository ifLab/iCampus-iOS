//
//  PJYellowPageTableView.h
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJYellowPageTableViewDelegate <NSObject>

- (void)PJYellowPageTableViewCellClick:(NSDictionary *)dict;
- (void)PJYellowPageTableView:(UITableView *)tableView scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

@interface PJYellowPageTableView : UITableView <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, weak) id<PJYellowPageTableViewDelegate> tableDelegate;

@end
