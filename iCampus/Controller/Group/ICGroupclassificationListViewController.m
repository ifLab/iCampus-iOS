//
//  ICGroupclassificationListViewController.m
//  iCampus
//
//  Created by Rex Ma on 14-5-23.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICGroupclassificationListViewController.h"
#import "ICUser.h"
#import "ICLoginViewController.h"

@interface ICGroupclassificationListViewController () <ICLoginViewControllerDelegate>

@property (strong,nonatomic) NSArray *nclass;
@property (strong,nonatomic) NSArray *nclassString;
@property BOOL firstLog;

@end

@implementation ICGroupclassificationListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.firstLog =YES;
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
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.firstLog) {
        self.firstLog = NO;
        if (!ICCurrentUser) {
            [self performSegueWithIdentifier:@"IC_GROUP_LIST_TO_LOGIN" sender:self];
            return;
        } else {
            [self loginViewController:nil user:ICCurrentUser didLogin:YES];
        }
    }
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
    return [self.nclass count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.nclass[section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.nclassString[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableArray *group;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.nclass[indexPath.section][indexPath.row][@"group"];
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:  forIndexPath:indexPath];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"IC_GROUP_LIST_TO_LOGIN"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ICLoginViewController *loginViewController = (ICLoginViewController *)navigationController.topViewController;
        loginViewController.delegate = self;
    }
}

- (void)loginViewController:(ICLoginViewController *)loginViewContrller
                       user:(ICUser *)user
                   didLogin:(BOOL)success {
    if (!success) {
        [self BackToMainPage:self];
    } else {
        ICGroupclassificationListViewController *__self __weak = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSMutableArray *banji=[[NSMutableArray alloc]init];
//            NSMutableArray *shetuan = [[NSMutableArray alloc]init];
            
            NSString *urlString = [NSString stringWithFormat:@"http://jwcapi.iflab.org/usergroup.php?userid=%@",ICCurrentUser.ID];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:nil
                                                             error:nil];
            NSDictionary *json1 = [[NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:nil] firstObject];
            
//            NSDictionary *json2 = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectAtIndex:1];
            
            __self.nclassString = @[@"class",@"group"];
            
            [banji addObject:@{@"group": json1[@"group"]}];
//            [shetuan addObject:@{@"group": json2[@"group"]}];
            
            __self.nclass = [[NSArray alloc]initWithObjects:banji,/*shetuan,*/nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.tableView reloadData];
            });
        });
    }
}
                                                                        

- (IBAction)BackToMainPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
