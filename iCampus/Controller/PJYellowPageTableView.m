//
//  PJYellowPageTableView.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJYellowPageTableView.h"
#import "PJYellowPageTableViewCell.h"

@implementation PJYellowPageTableView {
    UISearchBar *_kSearchBar;
    NSMutableArray *_kSearchArr;
}

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
    
    _kSearchArr = [@[] mutableCopy];
    _kSearchBar = [UISearchBar new];
    _kSearchBar.delegate = self;
    _kSearchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    _kSearchBar.barTintColor = [UIColor whiteColor];
    _kSearchBar.backgroundImage = [[UIImage alloc]init];
    //测试
    _kSearchBar.tag = 10086;
    UITextField *searchField = [_kSearchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.layer.borderWidth = 1;
        searchField.layer.borderColor = RGB(200, 200, 200).CGColor;
        searchField.layer.cornerRadius = 8.0f;
        searchField.placeholder = @"搜索...";
        searchField.font = [UIFont boldSystemFontOfSize:14];
    }
    self.tableHeaderView = _kSearchBar;
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_kSearchArr.count > 0) {
        return _kSearchArr.count;
    } else {
        return _dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJYellowPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJYellowPageTableViewCell" forIndexPath:indexPath];
    if (_kSearchArr.count > 0) {
        cell.cellDataSource = _kSearchArr[indexPath.row];
    } else {
        cell.cellDataSource = _dataArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PJYellowPageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [_kSearchBar resignFirstResponder];
    [_tableDelegate PJYellowPageTableViewCellClick:_dataArr[indexPath.row]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText; {
    // 使用谓词匹配
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchText];
    if (_kSearchArr != nil) {
        [_kSearchArr removeAllObjects];
    }
    for (NSDictionary *dict in _dataArr) {
        NSString *str = dict[@"name"];
        if ([preicate evaluateWithObject:str]) {
            [_kSearchArr addObject:dict];
        }
    }
    [self reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -150) {
        [_tableDelegate PJYellowPageTableView:self scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_kSearchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_kSearchBar resignFirstResponder];
}

@end
