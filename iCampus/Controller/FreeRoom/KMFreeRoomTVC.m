//
//  KMClassRoomTVC.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-8-23.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMFreeRoomTVC.h"
#import "KMFreeRoomsModel.h"
#import "SVPullToRefresh.h"
#import "KMFreeRoomBuildingsTVC.h"
#import "MobClick.h"

@interface KMFreeRoomTVC ()

@property (copy, nonatomic) NSArray *data;

@end

@implementation KMFreeRoomTVC

- (NSArray *)data
{
    if (!_data) {
        _data = @[];
    }
    return _data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    __weak KMFreeRoomTVC *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [KMFreeRoomsModel getCampusList:^(BOOL success, NSArray *data, NSError *error){
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            if (success) {
                weakSelf.data = data;
                [weakSelf.tableView reloadData];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:error.localizedDescription
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToPopup:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    NSMutableArray *gestures = [self.view.gestureRecognizers mutableCopy];
    [gestures addObject:swipeGesture];
    self.view.gestureRecognizers = [gestures copy];
    
    [MobClick beginLogPageView:@"空闲教室模块"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.data.count == 0) {
        [self.tableView triggerPullToRefresh];
    }
}

- (void)swipeToPopup:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    KMCampusObject *currObj = (KMCampusObject *)self.data[indexPath.row];
    cell.textLabel.text = currObj.campusName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"to_building" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KMFreeRoomBuildingsTVC *buildingTVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    KMCampusObject *selectedCampus = (KMCampusObject *)self.data[indexPath.row];
    buildingTVC.campusCode = selectedCampus.campusCode;
    buildingTVC.title = selectedCampus.campusName;
}

- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [MobClick endLogPageView:@"空闲教室模块"];
}

@end
