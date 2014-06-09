//
//  ICUsedGoodMyListTableViewController.m
//  iCampus
//
//  Created by EricLee on 14-4-13.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodMyListTableViewController.h"
#import "ICUser.h"
#import "ICControllerConfig.h"
#import "ICUsedGood.h"
#import "ICUsedGoodType.h"
#import "ICUsedGoodListCell.h"
#import "../../View/UsedGood/ICUsedGoodDetailView.h"
#import "ICUsedGoodDetailViewController.h"
#import "../ICControllerConfig.h"
#import "ICUsedGoodFilterViewController.h"
#import "APNavigationController.h"
#import "AFNetworking.h"
#import "ICLoginViewController.h"

@interface ICUsedGoodMyListTableViewController () <ICLoginViewControllerDelegate>

@property BOOL firstAppear;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ICUsedGoodMyListTableViewController


- (void)viewDidAppear:(BOOL)animated {
    if (ICCurrentUser) {
        self.firstAppear = NO;
        self.datas=[NSMutableArray array];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *userID = ICCurrentUser.ID;
            //[self deleteGoodByID:@"20"];
            self.datas = [[NSMutableArray alloc]initWithArray:[ICUsedGood goodListWithUserID:userID]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    } else if (self.firstAppear) {
        self.firstAppear = NO;
        [self performSegueWithIdentifier:(NSString *)ICUsedGoodMyListToLoginIdentifier sender:self];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.firstAppear = YES;
    }
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.rowHeight = 72.0f;
    if (ICCurrentUser) {
        [self viewDidAppear:NO];
    }
    

}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Used_Good_Detail" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Used_Good_Detail"]) {
        ICUsedGoodDetailViewController *detailViewController = (ICUsedGoodDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        detailViewController.usedGood= self.datas[indexPath.row];
        detailViewController.del.hidden=NO;
    } else if ([segue.identifier isEqualToString:(NSString *)ICUsedGoodMyListToLoginIdentifier]) {
        UINavigationController *navigationViewController = (UINavigationController *)segue.destinationViewController;
        ICLoginViewController *loginViewController = (ICLoginViewController *)navigationViewController.topViewController;
        loginViewController.delegate = self;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICUsedGood *good= self.datas[indexPath.row];
    //rNSLog(@"%@",good.ID);
    static NSString *prefix = @"IC_USED_GOOD";
    NSString *identifier = [NSString stringWithFormat:@"%@_%d_%d", prefix, indexPath.row, indexPath.section];
    ICUsedGoodListCell *cell =
    [[ICUsedGoodListCell alloc]initWithUsedGood:good reuseIdentifier:identifier];
    
    // Configure the cell...
    
    return cell;
}




- (void)loginViewController:(ICLoginViewController *)loginViewContrller
                       user:(ICUser *)user
                   didLogin:(BOOL)success {
    [loginViewContrller dismissViewControllerAnimated:YES completion:nil];
}


@end
