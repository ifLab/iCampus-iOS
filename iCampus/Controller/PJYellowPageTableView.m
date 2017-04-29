//
//  PJYellowPageTableView.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJYellowPageTableView.h"
#import "PJYellowPageTableViewCell.h"

@implementation PJYellowPageTableView


- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"PJYellowPageTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJYellowPageTableViewCell"];
    self.tableFooterView = [UIView new];
    self.estimatedRowHeight = 44;
    self.rowHeight = UITableViewAutomaticDimension;
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJYellowPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJYellowPageTableViewCell" forIndexPath:indexPath];
    cell.cellDataSource = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableDelegate PJYellowPageTableViewCellClick:_dataArr[indexPath.row]];
}


@end
