//
//  ICUsedGoodFilterViewController.m
//  iCampus
//
//  Created by EricLee on 14-4-10.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodFilterViewController.h"
#import "ICUsedGoodType.h"
#import "ICUsedGoodFilterTableViewCell.h"

@interface ICUsedGoodFilterViewController ()

- (IBAction)dismiss:(id)sender;
@property (nonatomic, strong) NSMutableArray *typeList;

@end

@implementation ICUsedGoodFilterViewController

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
    self.typeList=[NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.typeList=[NSMutableArray arrayWithArray:[ICUsedGoodType typeList]];
        ICUsedGoodType *type = [[ICUsedGoodType alloc] init];
        type.ID =@"All";
        type.name = @"全部";
        [self.typeList addObject:type];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });

    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICUsedGoodFilterTableViewCell *cell =(ICUsedGoodFilterTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate usedGoodFilterView:self SelectedType:cell.type];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.typeList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICUsedGoodType *type = [self.typeList objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"TYPE_LIST_CELL";
      NSString *identifier = [NSString stringWithFormat:@"%@_%d_%d", CellIdentifier, indexPath.row, indexPath.section];
    ICUsedGoodFilterTableViewCell *cell = [[ICUsedGoodFilterTableViewCell alloc]initWithType:type reuseIdentifier:identifier];
    return cell;
}



- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
