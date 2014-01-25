//
//  ICYellowPageListViewController.m
//  iCampus
//
//  Created by Darren Liu on 13-12-25.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICYellowPageListViewController.h"
#import "../../View/YellowPage/ICYellowPageContactCell.h"
#import "../../Model/YellowPage/ICYellowPage.h"
#import "../ICControllerConfig.h"

@interface ICYellowPageListViewController ()

@property (nonatomic, strong) ICYellowPage *yellowPage;

@end

@implementation ICYellowPageListViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.rowHeight = 48.0;
    self.title = self.department.name;
    ICYellowPageListViewController __weak *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.yellowPage = [[ICYellowPage yellowPageWithDepartment:self.department] yellowPageSortedByPinyin];
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.tableView reloadData];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return self.yellowPage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICYellowPageContact *contact = [self.yellowPage contactAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)contact.index]];
    if (!cell) {
        cell = [[ICYellowPageContactCell alloc] initWithContact:contact
                                                reuseIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)contact.index]];
    }
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", [self.yellowPage contactAtIndex:indexPath.row].telephone];
    NSURL *url = [NSURL URLWithString:urlString];
#   if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_YELLOWPAGE_DIAL_MODULE_DEBUG)
        NSLog(@"%@ %@ %@", ICYellowPageDialTag, ICFetchingTag, urlString);
#   endif
    if (![[UIApplication sharedApplication] openURL:url]) {
#       ifdef IC_YELLOWPAGE_DIAL_MODULE_DEBUG
            NSLog(@"%@ %@ %@", ICYellowPageDialTag, ICFailedTag, urlString);
#       endif
        return;
    }
#   if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_YELLOWPAGE_DIAL_MODULE_DEBUG)
        NSLog(@"%@ %@ %@", ICYellowPageDialTag, ICSucceededTag, urlString);
#   endif
}

@end
