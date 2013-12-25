//
//  ICYellowPageViewController.m
//  iCampus
//
//  Created by Darren Liu on 13-12-25.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICYellowPageViewController.h"
#import "../../View/YellowPage/ICContactCell.h"
#import "../../Model/YellowPage/ICYellowPage.h"

@interface ICYellowPageViewController ()

@property (nonatomic, strong) ICYellowPage *yellowPage;

- (IBAction)dismiss:(id)sender;

@end

@implementation ICYellowPageViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.translucent = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.yellowPage = [ICYellowPage yellowPage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
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
        cell = [[ICContactCell alloc] initWithContact:contact
                                      reuseIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)contact.index]];
    }
    return cell;
}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
