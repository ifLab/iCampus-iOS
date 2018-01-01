//
//  PJLostTableView.h
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJLostTableViewCell.h"


@protocol PJLostTableViewDelegate <NSObject>

- (void)tableViewClick:(NSArray *)data index:(NSInteger)index;
- (void)tableViewClickToDetails:(NSDictionary *)data;

@end

@interface PJLostTableView : UITableView <UITableViewDelegate, UITableViewDataSource, PJLostTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) id<PJLostTableViewDelegate> tableDelegate;

@property (nonatomic)CGFloat excursionY;
@end
