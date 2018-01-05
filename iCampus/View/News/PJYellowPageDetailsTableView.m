//
//  PJYellowPageDetailsTableView.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJYellowPageDetailsTableView.h"
#import "PJYellowPageDetailsTableViewCell.h"

@implementation PJYellowPageDetailsTableView

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"PJYellowPageDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJYellowPageDetailsTableViewCell"];
    self.tableFooterView = [UIView new];
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
    PJYellowPageDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJYellowPageDetailsTableViewCell" forIndexPath:indexPath];
    cell.cellDataSource = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSDictionary *dic = @{
                          @"username" : [PJUser currentUser].first_name,
                          @"departmentname" : [NSString stringWithFormat:@"%@%@", self.departmentName, _dataArr[indexPath.row][@"name"]],
                          @"uploadtime" : dateString
                          };
    [MobClick event:@"ibistu_yellowpages_details" attributes:dic];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _dataArr[indexPath.row][@"telephone"]]] options:@{} completionHandler:^(BOOL success) {
        
    }];
    PJYellowPageDetailsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

@end
