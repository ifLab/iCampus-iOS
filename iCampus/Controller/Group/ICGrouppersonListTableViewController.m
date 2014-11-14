//
//  ICGrouppersonListTableViewController.m
//  iCampus
//
//  Created by Rex Ma on 14-5-23.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICGrouppersonListTableViewController.h"
#import "ICUser.h"

@interface ICGrouppersonListTableViewController ()

@property (strong,nonatomic) NSMutableArray *icgroup;
@property (strong,nonatomic) NSString *icgroupString;
@property (strong,nonatomic) NSMutableArray *userdata;

@end

@implementation ICGrouppersonListTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.icgroup = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    ICGrouppersonListTableViewController *__self __weak = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *user = [ICGroup personalInformationlist];
        
        __self.icgroupString = @"student";
        
        for (NSDictionary *a in user) {
            [__self.icgroup addObject:@{@"name":[a objectForKey:@"XM"]}];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [__self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.icgroup count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.icgroupString;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.icgroup[indexPath.row][@"name"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *user1 = [ICGroup personalInformationlist];
    self.userdata = [[NSMutableArray alloc]init];
    for (NSDictionary *b in user1) {
        [self.userdata addObject:@{@"name": [b objectForKey:@"XM"],
                                   @"userid": [b objectForKey:@"XH"]}];
    }
    [self performSegueWithIdentifier:@"IC_GROUP_PERSON_LIST_TO_DETAIL" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
    if ([[segue identifier] isEqualToString:@"IC_GROUP_PERSON_LIST_TO_DETAIL"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ICGrouppersonDetailTableViewController *detailViewSEController = (ICGrouppersonDetailTableViewController *)(segue.destinationViewController);
        detailViewSEController.detailItem = self.userdata[indexPath.row];
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
