//
//  ICJobFavoritesJobTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-5-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobFavoritesJobTableViewController.h"

@interface ICJobFavoritesJobTableViewController ()

@property ICJobFavoritesJobList *favoritesJobList;

@end

@implementation ICJobFavoritesJobTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.favoritesJobList = [ICJobFavoritesJobList loadData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoritesJobList.favoritesList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Job"];
    ICJob *job = self.favoritesJobList.favoritesList[indexPath.row];
    cell.textLabel.text = job.title;
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString: @"IC_JOB_FAVORITES_JOB_TO_JOB_DETAIL"]) {
        // 跳转到工作详情界面
        ICJobDetailTableViewController *jobTableViewController = (ICJobDetailTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        ICJob *job = self.favoritesJobList.favoritesList[indexPath.row];
        jobTableViewController.job = job;
        ICJobDetailTableViewController *controller = (ICJobDetailTableViewController*) segue.destinationViewController;
        controller.mode = [NSString stringWithFormat:@"DONT_NEED_LOAD_DATA_FROM_NET"];
    } else if ([segue.identifier isEqualToString:nil]) {}
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    ICJob *job = self.favoritesJobList.favoritesList[indexPath.row];
    [self.favoritesJobList deleteJob:job];
    self.favoritesJobList = [ICJobFavoritesJobList loadData];
    [self.tableView reloadData];
}

@end
