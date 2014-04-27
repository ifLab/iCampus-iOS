//
//  ICAccountViewController.m
//  iCampus
//
//  Created by Darren Liu on 14-3-29.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICAccountViewController.h"
#import "ICLoginViewController.h"
#import "ICControllerConfig.h"
#import "ICUser.h"
#import "AFNetworking.h"

@interface ICAccountViewController () <ICLoginViewControllerDelegate>

@end

@implementation ICAccountViewController

- (void)viewDidAppear:(BOOL)animated {
    if (ICCurrentUser) {
        [self loginViewController:nil
                             user:ICCurrentUser
                         didLogin:YES];
    }
}

- (void)         tableView:(UITableView *)tableView
   didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

- (void)loginViewController:(ICLoginViewController *)loginViewContrller
                       user:(ICUser *)user
                   didLogin:(BOOL)success {
    if (success) {
        UITableViewCell *loginCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                              inSection:0]];
        UITableViewCell *IDCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                inSection:1]];
        UITableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1
                                                                                                 inSection:1]];
        UITableViewCell *typeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2
                                                                                             inSection:1]];
        loginCell.userInteractionEnabled = NO;
        loginCell.textLabel.textColor = [UIColor grayColor];
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            loginCell.textLabel.text = @"已登录";
        } else {
            loginCell.textLabel.text = @"Already logged in";
        }
        NSInteger n = [self.tableView numberOfRowsInSection:1];
        for (int i = 0; i < n; i++) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i
                                                                                             inSection:1]];
            cell.hidden = NO;
        }
        IDCell.detailTextLabel.text = user.ID;
        nameCell.detailTextLabel.text = user.name;
        typeCell.detailTextLabel.text = user.type;
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:(NSString *)ICAccountToLoginIdentifier]) {
        UINavigationController *navigationController = ((UINavigationController *)segue.destinationViewController);
        ICLoginViewController *loginViewController = (ICLoginViewController *)navigationController.topViewController;
        loginViewController.delegate = self;
    }
}

@end
