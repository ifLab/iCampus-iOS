//
//  ICNewsCatViewController.m
//  iCampus
//
//  Created by Kwei Ma on 13-11-14.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsCatViewController.h"
#import "Model/News/ICNews.h"

@interface ICNewsCatViewController ()

@property (strong, nonatomic) ICNewsChannelList *channels;

@end

@implementation ICNewsCatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.tableView.rowHeight = 50.0;
    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0, 0, 0);
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NaviBackBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissMe:)];
    backBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    ICNewsCatViewController __weak *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        weakSelf.channels = [ICNewsChannelList channelList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CatsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.0, 320.0, 1.0)];
        line.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        [cell.contentView addSubview:line];
    }
    
    if (indexPath.row == 0) {
        UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 1.0)];
        lineTop.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        [cell.contentView addSubview:lineTop];
    }
    
    cell.textLabel.text = [self.channels channelAtIndex:indexPath.row].title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate catViewController:self didFinishSelectingCat:[self.channels channelAtIndex:indexPath.row]];
}

#pragma mark - Additional Functions

- (void)dismissMe:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
