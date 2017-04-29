//
//  PJBusTableView.h
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJBusTableViewDelegate <NSObject>

- (void)PJBusTableViewCellClick:(NSDictionary *)dict;

@end

@interface PJBusTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, weak) id<PJBusTableViewDelegate> tableDelegate;
@end
