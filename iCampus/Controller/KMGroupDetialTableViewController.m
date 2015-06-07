//
//  KMGroupDetialTableViewController.m
//  iCampus
//
//  Created by xlx on 15/5/26.
//  Copyright (c) 2015年 BISTU. All rights reserved.
//

#import "KMGroupDetialTableViewController.h"
#import "ICGroupMessage.h"
#import "KMPersonalMessageTabelViewController.h"
@interface KMGroupDetialTableViewController ()<GroupMessageProtocol>

@end

@implementation KMGroupDetialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _Message.delegate                          = self;
    [_Message receivedPersonnalMessage];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

    self.navigationItem.title                  = _Message.group;
}
- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.hidesBarsOnSwipe = true;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _Message.message.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *name            = [_Message.message[indexPath.row] valueForKey:@"XM"];
    NSString *sex             = [_Message.message[indexPath.row] valueForKey:@"XB"];
    NSString *number          = [_Message.message[indexPath.row] valueForKey:@"XH"];
    cell.textLabel.text       = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@",sex,number];
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    KMPersonalMessageTabelViewController *std = (KMPersonalMessageTabelViewController *)segue.destinationViewController;
    std.message                               = [[ICPersonalMessage alloc]init];
    std.message.userid                        = [_Message.message[self.tableView.indexPathForSelectedRow.row] valueForKey:@"XH"];
    std.message.name                          = [_Message.message[self.tableView.indexPathForSelectedRow.row] valueForKey:@"XM"];
}

- (void)loadCompelectMessage{
    [self.tableView reloadData];
}
@end
