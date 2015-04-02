//
//  ICGrouppersonDetailTableViewController.m
//  iCampus
//
//  Created by Rex Ma on 14-5-23.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICGrouppersonDetailTableViewController.h"
#import "ICUser.h"

@interface ICGrouppersonDetailTableViewController ()

@property (strong,nonatomic) NSMutableArray *personalInformation;
@property (strong,nonatomic) NSString *personalInformationString;

@end

@implementation ICGrouppersonDetailTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.personalInformation = [NSMutableArray array];
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
    ICGrouppersonDetailTableViewController *__self __weak = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.personalInformationString = @"p\\ersonalInformation";
        NSString *urlString = [NSString stringWithFormat:@"http://m.bistu.edu.cn/userinfo.php?userid=%@",[__self.detailItem objectForKey:@"userid"]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        NSDictionary *json = [[NSJSONSerialization JSONObjectWithData:data
                                                              options:kNilOptions
                                                                error:nil] firstObject];
        
        [__self.personalInformation addObject:@{@"name":@"Name",
                                              @"information": [self.detailItem objectForKey:@"name"]}];
        [__self.personalInformation addObject:@{@"name":@"ID",
                                              @"information": [self.detailItem objectForKey:@"userid"]}];
        [__self.personalInformation addObject:@{@"name": @"QQ",
                                              @"information": json[@"qq"]}];
        [__self.personalInformation addObject:@{@"name": @"Wechat",
                                              @"information": json[@"wechat"]}];
        [__self.personalInformation addObject:@{@"name": @"Mobile",
                                              @"information":json[@"mobile"]}];
        [__self.personalInformation addObject:@{@"name":@"Email",
                                              @"information":json[@"email"]}];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.personalInformation count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.personalInformationString;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.personalInformation[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.personalInformation[indexPath.row][@"information"];
    
    return cell;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:forIndexPath:indexPath];
    
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
