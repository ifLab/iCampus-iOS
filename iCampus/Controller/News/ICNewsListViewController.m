//
//  ICNewsListViewController.m
//  iCampus
//
//  Created by Kwei Ma on 13-11-6.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsListViewController.h"
#import "ICNewsChannelViewController.h"
#import "ICNewsDetailViewController.h"
#import "../ICControllerConfig.h"
#import "../../Model/News/ICNews.h"
#import "../../View/News/ICNewsCell.h"
#import "../../External/MBProgressHUD/MBProgressHUD.h"
#import "../../External/SVPullToRefresh/SVPullToRefresh.h"

@interface ICNewsListViewController () <ICNewsChannelDelegate>

@property BOOL isLoading;
@property NSUInteger page;

@end

@implementation ICNewsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isLoading = NO;
    self.title = @"新闻";
    self.tableView.rowHeight = 72.0f;
    self.navigationController.navigationBar.translucent = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.channel = [ICNewsChannelList channelList].firstChannel;
        __weak ICNewsListViewController *__self = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView addPullToRefreshWithActionHandler:^{
                [__self reloadNewsList];
            }];
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                [__self continueLoadingNewsList];
            }];
            self.title = self.channel.title;
            [self.tableView triggerPullToRefresh];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICNews *news = [self.newsList newsAtIndex:indexPath.row];
#   warning News with same title might cause error.
    ICNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:news.title];
    if (!cell) {
        cell = [[ICNewsCell alloc] initWithNews:news
                                reuseIdentifier:news.title];
    }
    return cell;
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:(NSString *)ICNewsListToDetailIdentifier
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:(NSString *)ICNewsListToChannelIdentifier]) {
        ICNewsChannelViewController *channelViewController = (ICNewsChannelViewController *)(((UINavigationController *)segue.destinationViewController).topViewController);
        channelViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:(NSString *)ICNewsListToDetailIdentifier]) {
        ICNewsDetailViewController *detailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        detailViewController.news = [self.newsList newsAtIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath
                                      animated:YES];
    }
}

- (void)reloadNewsList {
    self.page = 1;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.newsList = [ICNewsList newsListWithChannel:self.channel
                                              pageIndex:self.page];
        ICNewsListViewController __weak *__self = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.tableView reloadData];
            [__self.tableView.pullToRefreshView stopAnimating];
        });
    });
}

- (void)continueLoadingNewsList {
    if (self.isLoading) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.isLoading = YES;
        ICNewsList *newNewsList = [ICNewsList newsListWithChannel:self.channel
                                                        pageIndex:self.page+1];
        if (newNewsList.count != 0) {
            [self.newsList addNewsFromNewsList:newNewsList];
            self.page++;
        }
        ICNewsListViewController __weak *__self = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.tableView reloadData];
            self.isLoading = NO;
            [__self.tableView.infiniteScrollingView stopAnimating];
        });
    });
}

- (void)newsChannelViewController:(ICNewsChannelViewController *)controller
        didFinishSelectingChannel:(ICNewsChannel *)channel {
    [controller dismissViewControllerAnimated:YES completion:nil];
    self.channel = channel;
    self.title = self.channel.title;
    [self.tableView triggerPullToRefresh];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
