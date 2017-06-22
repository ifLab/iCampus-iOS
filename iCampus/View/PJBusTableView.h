//
//  PJBusTableView.h
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PJBusTableViewCell;
@protocol PJBusTableViewDelegate <NSObject>

- (void)PJBusTableViewCellClick:(NSDictionary *)dict;
- (void)PJRegister3DtouchCell:(PJBusTableViewCell *)cell;

@end

@interface PJBusTableView : UITableView <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, weak) id<PJBusTableViewDelegate> tableDelegate;
@end
