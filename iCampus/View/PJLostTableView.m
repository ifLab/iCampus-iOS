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
    if (iPhoneX) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 84);
    } else {
        // PJ ：好奇怪，按道理应该是-64才对，估计是iOS 11的锅
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    }
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [UIView new];
    
    [self registerNib:[UINib nibWithNibName:@"PJLostTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJLostTableViewCell"];
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 250;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (iPhoneX) {
            self.contentInset = UIEdgeInsetsMake(84, 0, 0, 0);
        } else {
            self.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
        self.scrollIndicatorInsets = self.contentInset;
    }
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
    PJLostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJLostTableViewCell" forIndexPath:indexPath];
    cell.cellDelagate = self;
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
