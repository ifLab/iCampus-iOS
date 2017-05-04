//
//  PJMyPublishLostTableView.m
//  iCampus
//
//  Created by #incloud on 2017/5/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJMyPublishLostTableView.h"
#import "PJMyPublishLostTableViewCell.h"

@implementation PJMyPublishLostTableView

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"PJMyPublishLostTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJMyPublishLostTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _tableDataArr.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJMyPublishLostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJMyPublishLostTableViewCell" forIndexPath:indexPath];
    cell.dataSource = _tableDataArr[indexPath.row];
    return cell;
}

@end
