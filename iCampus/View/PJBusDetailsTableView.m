//
//  PJBusDetailsTableView.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJBusDetailsTableView.h"
#import "PJBusDetailsTableViewCell.h"

@implementation PJBusDetailsTableView
{
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
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 80;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJBusDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJBusDetailsTableViewCell" forIndexPath:indexPath];
    cell.dataSource = _dataArr[indexPath.row];
    cell.type = [_dataArr[indexPath.row][@"isRed"] integerValue];
    
    if (indexPath.row == 0) {
        cell.topLineView.hidden = YES;
    }
    if (indexPath.row == _dataArr.count - 1) {
        cell.bottomLineView.hidden = YES;
    }

    return cell;
}

@end
