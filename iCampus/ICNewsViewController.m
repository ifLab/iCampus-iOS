//
//  ICNewsViewController.m
//  iCampus
//
//  Created by Kwei Ma on 13-11-6.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsViewController.h"
#import "Model/News/ICNews.h"

#import "ICNewsDetailViewController.h"

#import "External/MBProgressHUD/MBProgressHUD.h"

#import "External/SVPullToRefresh/SVPullToRefresh.h"

#import "ICNewsCatViewController.h"

#import "UIImageView+AFNetworking.h"

#define CELL_TITLELABEL_TAG 1001
#define CELL_THUMBNAIL_TAG 1002
#define CELL_PREVIEW_TAG 1003

@interface ICNewsViewController () <ICNewsCatDelegate>

@property NSUInteger currentPage;

@property (strong, nonatomic) UIButton *showMoreBtn;

@end

@implementation ICNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"News";
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NaviBackBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissMe:)];
    backBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.tableView.rowHeight = 72.0f;
    
    __weak ICNewsViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.channel = [ICNewsChannelList channelList].firstChannel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView addPullToRefreshWithActionHandler:^{
                [weakSelf insertRowsAtTop];
            }];
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                [weakSelf insertRowsAtBottom];
            }];
            [self.navigationController.navigationBar setTranslucent:NO];
            [self.tableView triggerPullToRefresh];
        });
    });
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = nil;
#warning Reusable Cell
    
    UILabel *titleLabel = nil;
    UIImageView *thumbnail = nil;
    UILabel *previewLabel = nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 66.7, 50.0)];
        thumbnail.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        thumbnail.tag = CELL_THUMBNAIL_TAG;
        thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        thumbnail.clipsToBounds = YES;
        [cell.contentView addSubview:thumbnail];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(86.0, 10.0, 224.0, 18.0)];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.textColor = [UIColor darkTextColor];
        titleLabel.tag = CELL_TITLELABEL_TAG;
        [cell.contentView addSubview:titleLabel];
        
        previewLabel = [[UILabel alloc] initWithFrame:CGRectMake(86.0, 24.0, 224.0, 50.0)];
        previewLabel.font = [UIFont systemFontOfSize:12.0];
        previewLabel.numberOfLines = 2;
        previewLabel.lineBreakMode = NSLineBreakByCharWrapping;
        previewLabel.textColor = [UIColor grayColor];
        titleLabel.tag = CELL_PREVIEW_TAG;
        [cell.contentView addSubview:previewLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 1.0)];
        line.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [cell.contentView addSubview:line];
    } else {
        titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TITLELABEL_TAG];
        thumbnail = (UIImageView *)[cell.contentView viewWithTag:CELL_THUMBNAIL_TAG];
        previewLabel = (UILabel *)[cell.contentView viewWithTag:CELL_PREVIEW_TAG];
    }
    
    NSURL *url = [self.newsList newsAtIndex:indexPath.row].iconUrl;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    __weak UIImageView *weakThumbnail = thumbnail;
    [thumbnail setImageWithURLRequest:request
                     placeholderImage:nil
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  weakThumbnail.image = image;
                              }
                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                  weakThumbnail.image = nil;
                              }];
    
    
    titleLabel.text = [self.newsList newsAtIndex:indexPath.row].title;
    previewLabel.text = [self.newsList newsAtIndex:indexPath.row].preview;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ToNewsDetail" sender:self];
}


#pragma mark - Transaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"ToCatSelector"]) {
        ICNewsCatViewController *catVC = (ICNewsCatViewController *)(((UINavigationController *)segue.destinationViewController).topViewController);
        catVC.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"ToNewsDetail"]) {
        ICNewsDetailViewController *detailVC = (ICNewsDetailViewController *)segue.destinationViewController;
        detailVC.news = [self.newsList newsAtIndex:selectedIndex.row];
    }
    
    [self.tableView deselectRowAtIndexPath:selectedIndex animated:YES];
}


#pragma mark - Additional Functions

- (void)dismissMe:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data Loading

- (void)insertRowsAtTop
{
    __weak ICNewsViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        weakSelf.currentPage = 1;
        weakSelf.newsList = [ICNewsList newsListWithChannel:self.channel pageIndex:self.currentPage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        });
    });
}

- (void)insertRowsAtBottom
{
    __weak ICNewsViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        weakSelf.currentPage++;
        ICNewsList *newNewsList = [ICNewsList newsListWithChannel:self.channel
                                                        pageIndex:weakSelf.currentPage];
        [weakSelf.newsList addNewsFromNewsList:newNewsList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    });
}

#pragma mark - ICNewsCatViewControllerDelegate

- (void)catViewController:(ICNewsCatViewController *)catVC didFinishSelectingCat:(ICNewsChannel *)channel
{
    [catVC dismissViewControllerAnimated:YES completion:nil];
    self.channel = channel;
    self.title = self.channel.title;
    [self.tableView triggerPullToRefresh];
}

@end
