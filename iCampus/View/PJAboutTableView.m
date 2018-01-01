//
//  PJAboutTableView.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJAboutTableView.h"
#import "PJAboutTableViewCell.h"

@implementation PJAboutTableView

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableFooterView = [UIView new];
    [self registerNib:[UINib nibWithNibName:@"PJAboutTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJAboutTableViewCell"];
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJAboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJAboutTableViewCell" forIndexPath:indexPath];
    cell.dataSource = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"about%d", (NSInteger)indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PJAboutTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [_tableDelegate PJAboutTableViewCellClick:_dataArr[indexPath.row]];
}

@end
