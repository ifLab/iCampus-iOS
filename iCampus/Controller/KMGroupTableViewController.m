//
//  KMGroupTableViewController.m
//  iCampus
//
//  Created by xlx on 15/5/26.
//  Copyright (c) 2015年 BISTU. All rights reserved.
//

#import "KMGroupTableViewController.h"
#import "ICModelConfig.h"
#import "ICUser.h"
#import "ICGroup.h"
#import "KMGroupDetialTableViewController.h"
#import "ICLoginViewController.h"
#import "ICGroupMessage.h"
@interface KMGroupTableViewController ()<ICLoginViewControllerDelegate,GroupProtocol>
@property (nonatomic       ) BOOL           firstAppear;
@property (nonatomic,strong) NSArray        *sectionname;
@property (nonatomic,strong) NSMutableArray *sectionconnent;
@property (nonatomic,strong) ICGroup        *Personal;
@end

@implementation KMGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sectionname       = @[@"班级",@"组织"];
    _sectionconnent    = (NSMutableArray *)@[@"班级",@"未加入组织"];
    self.firstAppear   = true;
    _Personal          = [[ICGroup alloc]init];
    _Personal.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!ICCurrentUser && self.firstAppear) {
        self.firstAppear = false;
        [self performSegueWithIdentifier:@"IC_GROUP_TO_LOGIN" sender:self];
    }else{
        [_Personal receivedPersonnalMessage:ICCurrentUser.ID];
    }
}
- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }else{
        if (_sectionconnent.count-1 == 0) {
            return 1;
        }
        return _sectionconnent.count-1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text   = _sectionconnent[indexPath.section];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _sectionname[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 100;
    }
    return 50;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"IC_GROUP_TO_LOGIN"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ICLoginViewController *loginViewController   = (ICLoginViewController *)navigationController.topViewController;
        loginViewController.delegate                 = self;
    }else{
        KMGroupDetialTableViewController *std        = (KMGroupDetialTableViewController *)segue.destinationViewController;
        std.Message                                  = [[ICGroupMessage alloc]init];
        int index                                    = (int)self.tableView.indexPathForSelectedRow.row;
        index                                        += self.tableView.indexPathForSelectedRow.section;
        std.Message.group                            = _Personal.group[index];
        std.Message.groupid                          = _Personal.groupid[index];
        std.Message.type                             = _Personal.type[index];
        std.Message.userid                           = _Personal.userid[index];
    }
}

- (void)loginViewController:(ICLoginViewController *)loginViewContrller user:(ICUser *)user didLogin:(BOOL)success {
    if (success) {
        /**
         *  接收个人信息；
         *  返回一个NSDictionary；
         */
        [_Personal receivedPersonnalMessage:ICCurrentUser.ID];
    } else {
        [self dismiss:self];
    }
}
- (void)loadCompelect{

    NSArray *temp              = (NSArray *)_Personal.message;
    _Personal.group            = [[NSMutableArray alloc]init];
    _Personal.groupid          = [[NSMutableArray alloc]init];
    _Personal.type             = [[NSMutableArray alloc]init];
    _Personal.userid           = [[NSMutableArray alloc]init];
    for (int i = 0; i < temp.count; i++) {
        NSDictionary *tempDict = temp[i];
        NSString *group        = [NSString stringWithFormat:@"%@",[tempDict valueForKey:@"group"]];
        [_Personal.group addObject:group];
        NSString *groupid      = [NSString stringWithFormat:@"%@",[tempDict valueForKey:@"groupid"]];
        [_Personal.groupid addObject:groupid];
        NSString *type         = [NSString stringWithFormat:@"%@",[tempDict valueForKey:@"type"]];
        [_Personal.type addObject:type];
        NSString *userid       = [NSString stringWithFormat:@"%@",[tempDict valueForKey:@"userid"]];
        [_Personal.userid addObject:userid];
    }
    _sectionconnent            = _Personal.group;
    if (_sectionconnent.count == 1) {
        [_sectionconnent addObject:@"未加入任何组织"];
    }
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![cell.textLabel.text isEqualToString:@"未加入任何组织"]) {
        if (_Personal.group) {
            [self performSegueWithIdentifier:@"IC_GROUP_TO_DETIAL" sender:self];
        }else{
            [_Personal receivedPersonnalMessage:ICCurrentUser.ID];
        }
    }
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:true];
}
@end

























