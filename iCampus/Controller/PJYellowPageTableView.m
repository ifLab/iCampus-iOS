//
//  PJYellowPageTableView.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJYellowPageTableView.h"
#import "PJYellowPageTableViewCell.h"
#import "ChineseString.h"

@implementation PJYellowPageTableView {
    UISearchBar *_kSearchBar;
    NSMutableArray *_kSearchArr;
    NSMutableArray *_kSectionTitle;
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
    
    _kSectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
}

- (void)setIndexArray:(NSMutableArray *)indexArray {
    _indexArray = indexArray;
    for (int i = (int)_indexArray.count-1; i>=0; i--) {
        if ([_indexArray[i] count] == 0) {
            [_kSectionTitle removeObjectAtIndex:i];
            [_indexArray removeObjectAtIndex:i];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_kSearchArr.count > 0) {
        return 1;
    }else{
        return self.indexArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_kSearchArr.count > 0) {
        return _kSearchArr.count;
    } else {
        return [_indexArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJYellowPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJYellowPageTableViewCell" forIndexPath:indexPath];
    if (_kSearchArr.count > 0) {
        cell.dataDict = _kSearchArr[indexPath.row];
    } else {
        cell.cellDataSource = _indexArray[indexPath.section][indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PJYellowPageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [_kSearchBar resignFirstResponder];
    for (int i=0; i<_dataArr.count; i++) {
        NSDictionary *dict = _dataArr[i];
        NSString *shortStr = [dict objectForKey:@"name"];
        ChineseString *cString = _indexArray[indexPath.section][indexPath.row];
        if ([shortStr isEqualToString:cString.string]) {
            [_tableDelegate PJYellowPageTableViewCellClick:_dataArr[i]];
            break;
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_kSearchArr.count > 0) {
        return 0;
    }else{
        return 30;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_kSearchArr.count > 0) {
        return nil;
    }else{
        if ([self.indexArray[section] count] == 0) {
            return nil;
        }else{
            return [_kSectionTitle objectAtIndex:section];
        }
    }
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (_kSearchArr.count > 0) {
        return nil;
    }else{
        return _kSectionTitle;
    }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    if (![_indexArray[index] count]) {
        return 0;
    }else{
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        return index;
    }
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
