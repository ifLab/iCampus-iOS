//
//  ICBusViewController.m
//  iCampus
//
//  Created by Kwei Ma on 12/2/13.
//  Copyright (c) 2013 BISTU. All rights reserved.
//

#import "ICBusViewController.h"
#import "../../Model/Bus/ICBus.h"
#import "../../View/Bus/ICBusCell.h"
#import "../../View/Bus/ICBusStationListCell.h"

@interface ICBusViewController ()

@property (nonatomic, strong) ICBusListArray *busLines          ;
@property (nonatomic, copy)   NSIndexPath    *expandingIndexPath;

@end

@implementation ICBusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(15.0, 0, 0, 0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.busLines = [ICBusListArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.busLines.count;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    if (self.expandingIndexPath && self.expandingIndexPath.section == section) {
        return [self.busLines busListAtIndex:section].count + 1;
    }
    return [self.busLines busListAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.expandingIndexPath && self.expandingIndexPath.section == indexPath.section) {
        if (self.expandingIndexPath.row == indexPath.row) {
            return [[ICBusStationListCell alloc] initWithStationList:[[self.busLines busListAtIndex:indexPath.section]
                                                                      busAtIndex:indexPath.row - 1].stationList
                                                     reuseIdentifier:@"IC_BUS_STATION_LIST_CELL"];
        } else if (self.expandingIndexPath.row < indexPath.row) {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1
                                           inSection:indexPath.section];
        }
    }
    ICBus *bus = [[self.busLines busListAtIndex:indexPath.section] busAtIndex:indexPath.row];
    ICBusCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)bus.index]];
    if (!cell) {
        cell = [[ICBusCell alloc] initWithBus:bus
                              reuseIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)bus.index]];
    }
    return cell;
}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.expandingIndexPath]) {
        return 120.0;
    }
    return 72.0;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    if (self.expandingIndexPath) {
        NSIndexPath *expandingIndexPath = self.expandingIndexPath;
        self.expandingIndexPath = nil;
        [tableView deleteRowsAtIndexPaths:@[expandingIndexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        if (expandingIndexPath.section == indexPath.section) {
            if (expandingIndexPath.row - 1 == indexPath.row ||
                expandingIndexPath.row == indexPath.row) {
                return;
            } else if (expandingIndexPath.row - 1 < indexPath.row) {
                indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1
                                               inSection:indexPath.section];
            }
        }
    }
    self.expandingIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                 inSection:indexPath.section];
    [tableView insertRowsAtIndexPaths:@[self.expandingIndexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    [tableView scrollToRowAtIndexPath:self.expandingIndexPath
                     atScrollPosition:UITableViewScrollPositionMiddle
                             animated:YES];
}

- (UIView *)   tableView:(UITableView *)tableView
  viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.0)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [self.busLines busListAtIndex:section].name;
    return label;
}

- (CGFloat)      tableView:(UITableView *)tableView
  heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
