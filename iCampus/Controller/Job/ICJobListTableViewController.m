//
//  ICJobListTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobListTableViewController.h"
#import "ICJob.h"
#import "ICUser.h"
#import "ICLoginViewController.h"
#import "MBProgressHUD.h"

@interface ICJobListTableViewController ()

@property (nonatomic, strong)        UISegmentedControl  *segmentedControl;
@property (nonatomic, weak) IBOutlet UIButton            *classificationButton;
@property (nonatomic, strong)        MBProgressHUD       *HUD;
@property (nonatomic, strong)        UIView              *maskView;
@property (nonatomic, strong)        ICJobList           *jobList;
@property (nonatomic, strong)        ICJobClassification *classification;
@property (nonatomic)                BOOL                 type;
@property (nonatomic)                NSInteger            userID;
@property (nonatomic)                BOOL                 firstAppear;

- (IBAction)cancel:(id)sender;

@end

@implementation ICJobListTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.firstAppear = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    // 添加导航栏右侧按钮
    UIBarButtonItem *newJob, *more;
    newJob = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                          target:self
                                                          action:@selector(modalJobNewJobViewController:)];
    more = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ICNavigationBarCategoryIcon"]
                                           style:UIBarButtonItemStyleBordered
                                          target:self
                                          action:@selector(modalJobMoreViewController:)];
    self.navigationItem.rightBarButtonItems = @[more, newJob];
    
    // 添加兼全职切换按钮
    NSString *partTimeString;
    NSString *fullTimeString;
    NSString *allString;
    NSString *okString;
    NSString *loadFailedString;
    NSString *retryString;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        partTimeString = @"兼职";
        fullTimeString = @"全职";
        allString = @"全部";
        okString = @"好";
        loadFailedString = @"加载失败";
        retryString = @"请检查您的网络连接后重试。";
    } else {
        partTimeString = @"Part-time";
        fullTimeString = @"Full-time";
        allString = @"All";
        okString = @"OK";
        loadFailedString = @"Loading failed";
        retryString = @"Please check you network connection and try again.";
    }
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[partTimeString, fullTimeString]];
    self.segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 32);
//    NSDictionary *attributesDic = @{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                   NSFontAttributeName: [UIFont systemFontOfSize:16.0]};
//    [self.segmentedControl setTitleTextAttributes:attributesDic
//                                         forState:UIControlStateSelected];
    self.segmentedControl.tintColor = [UIColor colorWithRed:44/255.0 green:151/255.0 blue:222/255.0 alpha:1];
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    [self.segmentedControl addTarget:self
                              action:@selector(changeType:)
                    forControlEvents:UIControlEventValueChanged];
    
    // 数据初始化
    self.jobList = [[ICJobList alloc] init];
    self.type = 0;
    self.segmentedControl.selectedSegmentIndex = self.type;
    self.classification = [[ICJobClassification alloc] init];
    self.classification.index = 0;
    self.classification.title = allString;
    [self.classificationButton setTitle:self.classification.title forState:UIControlStateNormal];
    
    [self.tableView reloadData];
    
    // 数据获取
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    ICJobListTableViewController __weak *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.jobList = [ICJobList loadJobListWithType:__self.type classification:__self.classification];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (__self.jobList == nil) {
                [__self.HUD hide:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                [[[UIAlertView alloc]initWithTitle:loadFailedString
                                           message:retryString
                                          delegate:nil
                                 cancelButtonTitle:okString
                                 otherButtonTitles:nil]show];
            } else {
                [__self.tableView reloadData];
                [__self.HUD hide:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    });
}

//#warning 兼职模块未开启登录验证
///*
- (void)viewDidAppear:(BOOL)animated {
    if (!ICCurrentUser && self.firstAppear) {
        self.firstAppear = NO;
        [self performSegueWithIdentifier:(NSString *)@"IC_JOB_LIST_TO_LOGIN" sender:self];
    }
}//*/

- (IBAction)modalJobNewJobViewController:(id)sender {
    [self performSegueWithIdentifier:(NSString *)@"IC_JOB_LIST_TO_NEW" sender:self];
}
- (IBAction)modalJobMoreViewController:(id)sender {
    [self performSegueWithIdentifier:(NSString *)@"IC_JOB_LIST_TO_MORE" sender:self];
}
- (IBAction)modalJobClassificationListTableViewController:(id)sender {
    [self performSegueWithIdentifier:(NSString *)@"IC_JOB_LIST_TO_CLASSIFICATION" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return self.jobList.jobList.count;
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
    if ([segue.identifier isEqualToString: @"IC_JOB_LIST_TO_JOB_DETAIL"]) {
        // 跳转到工作详情界面
        ICJobDetailTableViewController *jobTableViewController = (ICJobDetailTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        ICJob *job = self.jobList.jobList[indexPath.row];
        jobTableViewController.jobID = job.index;
        ICJobDetailTableViewController *controller = (ICJobDetailTableViewController*) segue.destinationViewController;
        controller.mode = [NSString stringWithFormat:@"APPEAR_FAVORITES_BUTTON"];
    } else if ([segue.identifier isEqualToString:@"IC_JOB_LIST_TO_CLASSIFICATION"]) {
        // 跳转到分类列表
        UINavigationController *navigationController = segue.destinationViewController;
        ICJobClassificationListTableViewController *controller = (ICJobClassificationListTableViewController*) navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"IC_JOB_LIST_TO_LOGIN"]) {
        // 跳转到登录界面
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ICLoginViewController *loginViewController = (ICLoginViewController *)navigationController.topViewController;
        loginViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"IC_JOB_LIST_TO_NEW"]) {
        // 跳转到发布界面
        UINavigationController *navigationController = segue.destinationViewController;
        ICJobClassificationListTableViewController *controller = (ICJobClassificationListTableViewController*) navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"IC_JOB_LIST_TO_MORE"]) {
        // 跳转到更多界面
        UINavigationController *navigationController = segue.destinationViewController;
        ICJobClassificationListTableViewController *controller = (ICJobClassificationListTableViewController*) navigationController.topViewController;
        controller.delegate = self;
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)needReloadData {
    // 数据获取
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.jobList = [ICJobList loadJobListWithType:self.type classification:self.classification];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.jobList == nil) {
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
                                          delegate:nil
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

- (IBAction)changeType:(id)sender {
    if (self.type == NO) {
        self.type = YES;
    } else {
        self.type = NO;
    }
    
    // 数据获取
    [self.HUD show:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.jobList = [ICJobList loadJobListWithType:self.type classification:self.classification];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.jobList == nil) {
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
                                          delegate:nil
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

- (void)changeClassificationWith:(ICJobClassification*)classification {
    self.classification = classification;
    [self.classificationButton setTitle:self.classification.title forState:UIControlStateNormal];
    
    // 数据获取
    [self.HUD show:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.jobList = [ICJobList loadJobListWithType:self.type classification:self.classification];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.jobList == nil) {
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
                                          delegate:nil
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

-     (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 48;
    }
    return 0;
}

-  (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
        self.segmentedControl.center = view.center;
        view.backgroundColor = self.segmentedControl.backgroundColor;
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, .5)];
        line1.backgroundColor = [UIColor lightGrayColor];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, self.view.frame.size.width, .5)];
        line2.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:self.segmentedControl];
        [view addSubview:line1];
        [view addSubview:line2];
        return view;
    }
    return nil;
}

- (void)loginViewController:(ICLoginViewController *)loginViewContrller
                       user:(ICUser *)user
                   didLogin:(BOOL)success {
    if (!success) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
