//
//  KMFreeRoomRoomsTVC.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14/10/20.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMFreeRoomRoomsTVC.h"
#import "KMFreeRoomsModel.h"
#import "SVPullToRefresh.h"
#import "KMFreeRoomDetailTVC.h"

@interface KMFreeRoomRoomsTVC ()

@property (copy, nonatomic) NSArray *data;

@end

@implementation KMFreeRoomRoomsTVC

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
    
    __weak KMFreeRoomRoomsTVC *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [KMFreeRoomsModel getRoomListWithBuildingID:weakSelf.buildingCode :^(BOOL success, NSArray *data, NSError *error){
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
    
    KMRoomObject *currObj = (KMRoomObject *)self.data[indexPath.row];
    
    cell.textLabel.text = currObj.roomName;
    cell.detailTextLabel.text = currObj.roomCapacity;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"to_detail" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KMFreeRoomDetailTVC *detailTVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    KMRoomObject *selectedRoom = (KMRoomObject *)self.data[indexPath.row];
    detailTVC.roomCode = selectedRoom.roomCode;
    detailTVC.title = selectedRoom.roomName;
}

@end
