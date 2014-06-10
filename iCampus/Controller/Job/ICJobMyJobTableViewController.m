//
//  ICJobMyJobTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-5-24.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobMyJobTableViewController.h"
#import "ICJob.h"
#import "ICJobDetailTableViewController.h"
#import "ICUser.h"
#import "MBProgressHUD.h"

@interface ICJobMyJobTableViewController ()

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (strong, nonatomic) ICJobList *jobList;

@end

@implementation ICJobMyJobTableViewController

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
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jobList.jobList.count;;
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Job"];
    ICJob *job = self.jobList.jobList[indexPath.row];
    cell.textLabel.text = job.title;
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString: @"IC_JOB_MY_JOB_TO_JOB_DETAIL"]) {
        // 跳转到工作详情界面
        ICJobDetailTableViewController *jobTableViewController = (ICJobDetailTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        ICJob *job = self.jobList.jobList[indexPath.row];
        jobTableViewController.jobID = job.index;
        ICJobDetailTableViewController *controller = (ICJobDetailTableViewController*) segue.destinationViewController;
        controller.mode = [NSString stringWithFormat:@"APPEAR_DEL_FROM_MINE_BUTTON"];
    } else if ([segue.identifier isEqualToString:nil]) {}
}

- (void) getData {
    // 数据获取
    if (!ICCurrentUser) {
        return;
    }
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.jobList = [ICJobList loadJobListWithID:ICCurrentUser.ID];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.jobList == nil) {
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
                                          delegate:nil
                                 cancelButtonTitle:okString
                                 otherButtonTitles:nil]show];
            } else {
                [self.tableView reloadData];
                [self.HUD hide:YES];
            }
        });
    });
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    ICJob *job = self.jobList.jobList[indexPath.row];
    NSString *u = [NSString stringWithFormat:@"http://m.bistu.edu.cn/newapi/job_unvalid.php?id=%lu", (unsigned long)job.index];
    NSURL *url = [[NSURL alloc] initWithString:u];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                         returningResponse:nil
                                                     error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:nil];
    NSInteger success = [json[@"id"] intValue];
    NSString *okString;
    NSString *failedString;
    NSString *retryString;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        okString = @"好";
        failedString = @"删除失败";
        retryString = @"请检查您的网络连接后重试。";
    } else {
        okString = @"OK";
        failedString = @"Remove failed";
        retryString = @"Please check you network connection and try again.";
    }
    if (!data || success != 0) {
        [self.HUD hide:YES];
        [[[UIAlertView alloc]initWithTitle:failedString
                                   message:retryString
                                  delegate:nil
                         cancelButtonTitle:okString
                         otherButtonTitles:nil]show];
    } else {
        [self.HUD hide:YES];
        [self getData];
        [self.delegate tellICJobListTableViewControllerNeedReloadData];
    }
}

@end
