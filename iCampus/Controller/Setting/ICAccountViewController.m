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
#import "ICAccountEditViewController.h"

@interface ICAccountViewController () <ICLoginViewControllerDelegate, ICAccoutEditViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *loginCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *IDCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *typeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *QQCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *WeChatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *mobileCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (nonatomic) NSInteger numberOfSections;
@property (strong, nonatomic) NSArray *rightBarButtonItems;

@end

@implementation ICAccountViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.numberOfSections = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightBarButtonItems = self.navigationItem.rightBarButtonItems;
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
        self.loginCell.userInteractionEnabled = NO;
        self.loginCell.textLabel.textColor = [UIColor grayColor];
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            self.loginCell.textLabel.text = @"已登录";
        } else {
            self.loginCell.textLabel.text = @"Already logged in";
        }
        self.IDCell.detailTextLabel.text = user.ID;
        self.nameCell.detailTextLabel.text = user.name;
        self.typeCell.detailTextLabel.text = user.type;
        self.QQCell.detailTextLabel.text = user.QQ;
        self.WeChatCell.detailTextLabel.text = user.WeChat;
        self.mobileCell.detailTextLabel.text = user.mobile;
        self.emailCell.detailTextLabel.text = user.email;
        self.numberOfSections = 3;
        self.navigationItem.rightBarButtonItems = self.rightBarButtonItems;
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        [loginViewContrller dismissViewControllerAnimated:YES
                                               completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:(NSString *)ICAccountToLoginIdentifier]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ICLoginViewController *loginViewController = (ICLoginViewController *)navigationController.topViewController;
        loginViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:(NSString *)ICAccountToEditIdentifier]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ICAccountEditViewController *editViewController = (ICAccountEditViewController *)navigationController.topViewController;
        editViewController.delegate = self;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.numberOfSections;
}

- (void)accountEditViewController:(ICAccountEditViewController *)accountEditViewController
             didDismissWithStatus:(ICAccountEditViewControllerDismissStatus)status {
    [accountEditViewController dismiss:self];
    if (status == ICAccountEditViewControllerDismissStatusDone) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([ICCurrentUser login]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loginViewController:nil
                                         user:ICCurrentUser
                                     didLogin:YES];
                    
                });
            }
        });
    }
}

@end
