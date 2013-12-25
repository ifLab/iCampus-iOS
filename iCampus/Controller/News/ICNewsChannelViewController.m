//
//  ICNewsCatViewController.m
//  iCampus
//
//  Created by Kwei Ma on 13-11-14.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsChannelViewController.h"
#import "../../Model/News/ICNews.h"
#import "../../View/News/ICNewsChannelCell.h"

@interface ICNewsChannelViewController ()

@property (strong, nonatomic) ICNewsChannelList *channels;

- (IBAction)dismiss:(id)sender;

@end

@implementation ICNewsChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.tableView.rowHeight = 50.0;
    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0, 0, 0);
    ICNewsChannelViewController __weak *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.channels = [ICNewsChannelList channelList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.tableView reloadData];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICNewsChannel *channel = [self.channels channelAtIndex:indexPath.row];
    ICNewsChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:channel.title];
    if (cell == nil) {
        if (indexPath.row == 0) {
            cell = [[ICNewsChannelCell alloc] initWithChannel:channel
                                              reuseIdentifier:channel.title
                                                      isFirst:YES];
        } else {
            cell = [[ICNewsChannelCell alloc] initWithChannel:channel
                                              reuseIdentifier:channel.title
                                                      isFirst:NO];
        }
    }
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate newsChannelViewController:self
                   didFinishSelectingChannel:[self.channels channelAtIndex:indexPath.row]];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
