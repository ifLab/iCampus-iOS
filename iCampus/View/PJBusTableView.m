//
//  PJBusTableView.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJBusTableView.h"
#import "PJBusTableViewCell.h"

@implementation PJBusTableView

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self registerNib:[UINib nibWithNibName:@"PJBusTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJBusTableViewCell"];
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 60;
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
    PJBusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJBusTableViewCell" forIndexPath:indexPath];
    cell.cellDataSource = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PJBusTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [_tableDelegate PJBusTableViewCellClick:_dataArr[indexPath.row]];
}


@end
