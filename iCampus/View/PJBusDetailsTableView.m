//
//  PJBusDetailsTableView.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJBusDetailsTableView.h"
#import "PJBusDetailsTableViewCell.h"

@implementation PJBusDetailsTableView {
    BOOL isRed;
}

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    isRed = NO;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = RGB(245, 245, 245);
    [self registerNib:[UINib nibWithNibName:@"PJBusDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJBusDetailsTableViewCell"];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJBusDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJBusDetailsTableViewCell" forIndexPath:indexPath];
    cell.dataSource = _dataArr[indexPath.row];
    cell.type = [_dataArr[indexPath.row][@"isRed"] integerValue];
    NSDictionary *cellDataSource = _dataArr[indexPath.row];
    
    // PJ : 这是之前遗留下来的字典数据，就这样吧，我反正是不想改了。心累。_(:зゝ∠)_
    if ([cellDataSource[@"isBottomLine"] isEqualToString:cellDataSource[@"isTopLine"]]) {
        cell.lineImageView.image = [UIImage imageNamed:@"LinePoint"];
    } else if ([_dataArr[indexPath.row][@"isTopLine"] isEqualToString:@"1"]) {
        cell.lineImageView.image = [UIImage imageNamed:@"bottomLinePoint"];
    } else if ([_dataArr[indexPath.row][@"isBottomLine"] isEqualToString:@"1"]) {
        cell.lineImageView.image = [UIImage imageNamed:@"topLinePoint"];
    }

    return cell;
}

@end
