//
//  ICYellowPageDepartmentViewController.m
//  iCampus
//
//  Created by Darren Liu on 14-1-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICYellowPageDepartmentViewController.h"
#import "../ICControllerConfig.h"
#import "../../Model/YellowPage/ICYellowPage.h"
#import "../../View/YellowPage/ICYellowPageDepartmentCell.h"
#import "ICYellowPageListViewController.h"

@interface ICYellowPageDepartmentViewController ()

@property (nonatomic, strong) ICYellowPageDepartmentList *departmentList;

@end

@implementation ICYellowPageDepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 48.0;
    self.clearsSelectionOnViewWillAppear = YES;
    ICYellowPageDepartmentViewController __weak *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.departmentList = [ICYellowPageDepartmentList departmentList];
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
    return self.departmentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICYellowPageDepartment *department = [self.departmentList departmentAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:department.name];
    if (!cell) {
        cell = [[ICYellowPageDepartmentCell alloc] initWithDepartment:department
                                                      reuseIdentifier:department.name];
    }
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:(NSString *)ICYellowPageDepartmentToListIdentifier
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    ICYellowPageListViewController *destinationViewController = (ICYellowPageListViewController *)segue.destinationViewController;
    destinationViewController.department = [self.departmentList departmentAtIndex:indexPath.row];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
