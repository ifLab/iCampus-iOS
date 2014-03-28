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
#import "../../External/SVPullToRefresh/SVPullToRefresh.h"

@interface ICNewsListViewController () <ICNewsChannelDelegate>

@property (nonatomic, getter = isLoading) BOOL loading;
@property (nonatomic)                     NSUInteger page;

@end

@implementation ICNewsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loading = NO;
    self.tableView.rowHeight = 72.0f;
    self.navigationController.navigationBar.translucent = NO;
    self.clearsSelectionOnViewWillAppear = YES;
    ICNewsListViewController __weak *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.channel = [ICNewsChannelList channelList].firstChannel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.tableView addPullToRefreshWithActionHandler:^{
                [__self reloadNewsList];
            }];
            [__self.tableView addInfiniteScrollingWithActionHandler:^{
                [__self continueLoadingNewsList];
            }];
            __self.title = __self.channel.title;
            [__self.tableView triggerPullToRefresh];
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
    ICNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)news.index]];
    if (!cell) {
        cell = [[ICNewsCell alloc] initWithNews:news
                                reuseIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)news.index]];
    }
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:(NSString *)ICNewsListToDetailIdentifier
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:(NSString *)ICNewsListToChannelIdentifier]) {
        ICNewsChannelViewController *channelViewController = (ICNewsChannelViewController *)(((UINavigationController *)segue.destinationViewController).topViewController);
        channelViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:(NSString *)ICNewsListToDetailIdentifier]) {
        ICNewsDetailViewController *detailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        detailViewController.news = [self.newsList newsAtIndex:indexPath.row];
    }
}

- (void)reloadNewsList {
    self.page = 1;
    ICNewsListViewController __weak *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.newsList = [ICNewsList newsListWithChannel:__self.channel
                                                pageIndex:__self.page];
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
    ICNewsListViewController __weak *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.loading = YES;
        ICNewsList *newNewsList = [ICNewsList newsListWithChannel:__self.channel
                                                        pageIndex:__self.page+1];
        if (newNewsList.count != 0) {
            [__self.newsList addNewsFromNewsList:newNewsList];
            __self.page++;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.tableView reloadData];
            __self.loading = NO;
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
