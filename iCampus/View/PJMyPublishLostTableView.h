//
//  PJMyPublishLostTableView.h
//  iCampus
//
//  Created by #incloud on 2017/5/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJMyPublishLostTableViewCell.h"

@protocol PJMyPublishLostTableViewDelegate <NSObject>

- (void)tableViewClick:(NSArray *)data index:(NSInteger)index;
- (void)trashClick:(NSIndexPath*)indexPath;
- (NSArray *)PJMyPublishLostTableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PJMyPublishLostTableView : UITableView <UITableViewDelegate ,UITableViewDataSource, PJMyPublishLostTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *tableDataArr;

@property (nonatomic, weak) id<PJMyPublishLostTableViewDelegate> tableDelegate;

@end
