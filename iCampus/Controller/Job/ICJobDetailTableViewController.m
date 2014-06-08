//
//  ICJobDetailTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-4-15.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobDetailTableViewController.h"
#import "ICJob.h"
#import "MBProgressHUD.h"

@interface ICJobDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *qualificationsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *salaryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *companyCell;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactQQLabel;
@property (nonatomic, strong) MBProgressHUD *HUD;

- (IBAction)cancel:(id)sender;



@end

@implementation ICJobDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.mode isEqual: @"DONT_NEED_LOAD_DATA_FROM_NET"]) {
        self.navigationItem.title = self.job.title;
        if (![self.job.description isKindOfClass:[NSNull class]])
            self.descriptionCell.textLabel.text = self.job.description;
        if (![self.job.location isKindOfClass:[NSNull class]])
            self.locationCell.textLabel.text = self.job.location;
        if (![self.job.qualifications isKindOfClass:[NSNull class]])
            self.qualificationsCell.textLabel.text = self.job.qualifications;
        if (![self.job.salary isKindOfClass:[NSNull class]])
            self.salaryCell.textLabel.text = self.job.salary;
        if (![self.job.company isKindOfClass:[NSNull class]])
            self.companyCell.textLabel.text = self.job.company;
        if (![self.job.contactName isKindOfClass:[NSNull class]])
            self.contactNameLabel.text = self.job.contactName;
        if (![self.job.contactPhone isKindOfClass:[NSNull class]])
            self.contactPhoneLabel.text = self.job.contactPhone;
        if (![self.job.contactEmail isKindOfClass:[NSNull class]])
            self.contactEmailLabel.text = self.job.contactEmail;
        if (![self.job.contactQQ isKindOfClass:[NSNull class]])
            self.contactQQLabel.text = self.job.contactQQ;
        [self.descriptionCell.textLabel sizeToFit];
        [self.locationCell.textLabel sizeToFit];
        [self.qualificationsCell.textLabel sizeToFit];
        [self.salaryCell.textLabel sizeToFit];
        [self.companyCell.textLabel sizeToFit];
        [self.tableView reloadData];
        return;
    }
    
    // 数据获取
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.job = [ICJob loadJobDetailWith:self.jobID];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.job == nil || self.job.index != self.jobID) {
                [self.HUD hide:YES];
                NSString *okString;
                NSString *loadFailedString;
                NSString *retryString;
                NSArray *languages = [NSLocale preferredLanguages];
                NSString *currentLanguage = [languages objectAtIndex:0];
                if ([currentLanguage isEqualToString:@"zh-Hans"]) {
                    okString = @"好";
                    loadFailedString = @"加载失败";
                    retryString = @"请检查您的网络连接后重试。";
                } else {
                    okString = @"OK";
                    loadFailedString = @"Loading failed";
                    retryString = @"Please check you network connection and try again.";
                }
                [[[UIAlertView alloc]initWithTitle:loadFailedString
                                           message:retryString
                                          delegate:self
                                 cancelButtonTitle:okString
                                 otherButtonTitles:nil]show];
            } else {
                self.navigationItem.title = self.job.title;
                if (![self.job.description isKindOfClass:[NSNull class]])
                    self.descriptionCell.textLabel.text = self.job.description;
                if (![self.job.location isKindOfClass:[NSNull class]])
                    self.locationCell.textLabel.text = self.job.location;
                if (![self.job.qualifications isKindOfClass:[NSNull class]])
                    self.qualificationsCell.textLabel.text = self.job.qualifications;
                if (![self.job.salary isKindOfClass:[NSNull class]])
                    self.salaryCell.textLabel.text = self.job.salary;
                if (![self.job.company isKindOfClass:[NSNull class]])
                    self.companyCell.textLabel.text = self.job.company;
                if (![self.job.contactName isKindOfClass:[NSNull class]])
                    self.contactNameLabel.text = self.job.contactName;
                if (![self.job.contactPhone isKindOfClass:[NSNull class]])
                    self.contactPhoneLabel.text = self.job.contactPhone;
                if (![self.job.contactEmail isKindOfClass:[NSNull class]])
                    self.contactEmailLabel.text = self.job.contactEmail;
                if (![self.job.contactQQ isKindOfClass:[NSNull class]])
                    self.contactQQLabel.text = self.job.contactQQ;
                [self.descriptionCell.textLabel sizeToFit];
                [self.locationCell.textLabel sizeToFit];
                [self.qualificationsCell.textLabel sizeToFit];
                [self.salaryCell.textLabel sizeToFit];
                [self.companyCell.textLabel sizeToFit];
                [self.tableView reloadData];
                [self.HUD hide:YES];
                
                // 添加导航栏右侧按钮
                if ([self.mode isEqual: @"APPEAR_FAVORITES_BUTTON"]) {
                    if ([ICJobFavoritesJobList checkJob:self.job]) {
                        self.favoritesButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"JobFavorites1"]
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(addOrDelFavorites:)];
                        self.navigationItem.rightBarButtonItems = @[self.favoritesButton];
                    } else {
                        self.favoritesButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"JobFavorites0"]
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(addOrDelFavorites:)];
                        self.navigationItem.rightBarButtonItems = @[self.favoritesButton];
                    }
                }
            }
        });
    });
}

- (IBAction)addOrDelFavorites:(id)sender {
    NSString *addedString;
    NSString *removedString;
    NSString *okString;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        addedString = @"成功添加到收藏";
        removedString = @"成功移除收藏";
        okString = @"好";
    } else {
        addedString = @"Successfully added to favourites.";
        removedString = @"Successfully removed from favourites.";
        okString = @"OK";
    }
    if ([ICJobFavoritesJobList addJob:self.job]) {
        [[[UIAlertView alloc]initWithTitle:addedString
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:okString
                         otherButtonTitles:nil]show];
        self.favoritesButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"JobFavorites1"]
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(addOrDelFavorites:)];
        self.navigationItem.rightBarButtonItems = @[self.favoritesButton];
        return;
    }
    if ([ICJobFavoritesJobList deleteJob:self.job]) {
        [[[UIAlertView alloc]initWithTitle:removedString
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:okString
                         otherButtonTitles:nil]show];
        self.favoritesButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"JobFavorites0"]
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(addOrDelFavorites:)];
        self.navigationItem.rightBarButtonItems = @[self.favoritesButton];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-    (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.descriptionCell.textLabel.frame.size.height + 22;
    }
    return 43;
}

- (void)     alertView:(UIAlertView *)alertView
  clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate appearSegmentedControl];
            break;
        }
        default: {break;}
    }
}

- (NSIndexPath*)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate appearSegmentedControl];
}

@end

