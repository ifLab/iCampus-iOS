//
//  ICJobClassificationListTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-4-20.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobClassificationListTableViewController.h"
#import "ICJob.h"
#import "MBProgressHUD.h"

@interface ICJobClassificationListTableViewController ()

- (IBAction)cancel:(id)sender;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (strong, nonatomic) ICJobClassificationList *jobClassificationList;

@end

@implementation ICJobClassificationListTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 数据获取
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.jobClassificationList = [ICJobClassificationList loadJobClassificationList];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.jobClassificationList == nil) {
                [self.HUD hide:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
                [self.tableView reloadData];
                [self.HUD hide:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)     alertView:(UIAlertView *)alertView
  clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default: {break;}
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.jobClassificationList.jobClassificationList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Classification"];
    ICJobClassification *jobClassification = self.jobClassificationList.jobClassificationList[indexPath.row];
    cell.textLabel.text = jobClassification.title;
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICJobClassification *jobClassification = self.jobClassificationList.jobClassificationList[indexPath.row];
    [self.delegate changeClassificationWith:jobClassification];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
