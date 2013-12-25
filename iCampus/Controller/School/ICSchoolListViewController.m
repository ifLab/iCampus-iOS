//
//  ICSchoolListViewController.m
//  iCampus
//
//  Created by Darren Liu on 13-12-22.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICSchoolListViewController.h"
#import "ICSchoolDetailViewController.h"
#import "../ICControllerConfig.h"
#import "../../Model/School/ICSchool.h"
#import "../../View/School/ICSchoolCell.h"

@interface ICSchoolListViewController ()

@property (nonatomic, strong) ICSchoolList *schoolList;

- (IBAction)dismiss:(id)sender;

@end

@implementation ICSchoolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.rowHeight = 56.0;
    ICSchoolListViewController __weak *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.schoolList = [ICSchoolList schoolList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.tableView reloadData];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICSchool *school = [self.schoolList schoolAtIndex:indexPath.row];
    ICSchoolCell *cell = [self.tableView dequeueReusableCellWithIdentifier:school.name];
    if (!cell) {
        cell = [[ICSchoolCell alloc] initWithSchool:school
                                    reuseIdentifier:school.name];
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return self.schoolList.count;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:(NSString *)ICSchoolListToDetailIdentifier
                              sender:self];
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:(NSString *)ICSchoolListToDetailIdentifier]) {
        ICSchoolDetailViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.school = [self.schoolList schoolAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
