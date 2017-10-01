//
//  PJLostTableView.m
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJLostTableView.h"

@implementation PJLostTableView

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [UIView new];
    
    [self registerNib:[UINib nibWithNibName:@"PJLostTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJLostTableViewCell"];
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 250;
    self.backgroundColor = RGB(232, 234, 236);
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJLostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJLostTableViewCell" forIndexPath:indexPath];
    cell.cellDelagate = self;
//    cell.pepleIconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", rand()%5]];
    cell.dataSource = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)cellClick:(NSArray *)data index:(NSInteger)index {
    [_tableDelegate tableViewClick:data index:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableDelegate tableViewClickToDetails:_dataArr[indexPath.row]];
}

@end
