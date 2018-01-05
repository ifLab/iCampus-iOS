//
//  PJAboutTableView.h
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJAboutTableViewDelegate <NSObject>

- (void)PJAboutTableViewCellClick:(NSDictionary *)dict;

@end

@interface PJAboutTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, weak) id<PJAboutTableViewDelegate> tableDelegate;

@end
