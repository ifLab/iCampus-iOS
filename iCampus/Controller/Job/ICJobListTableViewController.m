//
//  ICJobListTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobListTableViewController.h"

@interface ICJobListTableViewController ()

@property UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *classificationButton;
- (IBAction)cancel:(id)sender;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (strong, nonatomic) ICJobList *jobList;
@property ICJobClassification* classification;
@property BOOL type;
@property NSInteger userID;
@property BOOL firstAppear;

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
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"兼职", @"全职"]];
    self.segmentedControl.frame = CGRectMake(-3, 64, self.view.frame.size.width + 6, 40);
    NSDictionary *attributesDic = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                   NSFontAttributeName: [UIFont systemFontOfSize:16.0]};
    [self.segmentedControl setTitleTextAttributes:attributesDic
                                         forState:UIControlStateSelected];
    self.segmentedControl.tintColor = [UIColor colorWithRed:0.277 green:0.633 blue:0.871 alpha:1.0];
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    [self.segmentedControl addTarget:self
                              action:@selector(changeType:)
                    forControlEvents:UIControlEventValueChanged];
    [self.navigationController.view addSubview:self.segmentedControl];
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(40 + 10, 0, 0, 0);
    
    // 数据初始化
    self.jobList = [[ICJobList alloc] init];
    self.type = 0;
    self.segmentedControl.selectedSegmentIndex = self.type;
    self.classification = [[ICJobClassification alloc] init];
    self.classification.index = 0;
    self.classification.title = @"全部";
    [self.classificationButton setTitle:self.classification.title forState:UIControlStateNormal];
    
    [self.tableView reloadData];
    NSLog(@"兼职：初始化成功");
    NSLog(@"兼职：当前数据，类型：%@，类别：%@", (self.type ? @"全职" : @"兼职"), self.classification.title);
    
    // 数据获取
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.jobList = [ICJobList loadJobListWithType:self.type classification:self.classification];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.jobList == nil) {
                [self.HUD hide:YES];
                [[[UIAlertView alloc]initWithTitle:@"数据载入错误！"
                                           message:@"请检查您的网络连接后重试"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil]show];
            } else {
                [self.tableView reloadData];
                [self.HUD hide:YES];
                NSLog(@"兼职：工作列表数据载入成功");
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

- (void)appearSegmentedControl {
    self.segmentedControl.hidden = NO;
}
- (void)disappearSegmentedControl {
    self.segmentedControl.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
//#warning 若要显示搜索框则改为1，搜索框功能未实现
        return 0;
    }
    return self.jobList.jobList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Job"];
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"searchBarCell"];
        [cell addSubview:[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)]];
        return cell;
    }
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
        [self disappearSegmentedControl];
        ICJobDetailTableViewController *controller = (ICJobDetailTableViewController*) segue.destinationViewController;
        controller.delegate = self;
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
    NSLog(@"兼职：数据刷新");
    // 数据获取
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.jobList = [ICJobList loadJobListWithType:self.type classification:self.classification];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.jobList == nil) {
                [self.HUD hide:YES];
                [[[UIAlertView alloc]initWithTitle:@"数据载入错误！"
                                           message:@"请检查您的网络连接后重试"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil]show];
            } else {
                [self.tableView reloadData];
                [self.HUD hide:YES];
                NSLog(@"兼职：工作列表数据载入成功");
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
    NSLog(@"兼职：更改类型为：%@", (self.type ? @"全职" : @"兼职"));
    NSLog(@"兼职：当前数据，类型：%@，类别：%@", (self.type ? @"全职" : @"兼职"), self.classification.title);
    
    // 数据获取
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.jobList = [ICJobList loadJobListWithType:self.type classification:self.classification];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.jobList == nil) {
                [self.HUD hide:YES];
                [[[UIAlertView alloc]initWithTitle:@"数据载入错误！"
                                           message:@"请检查您的网络连接后重试"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil]show];
            } else {
                [self.tableView reloadData];
                [self.HUD hide:YES];
                NSLog(@"兼职：工作列表数据载入成功");
            }
        });
    });
}

- (void)changeClassificationWith:(ICJobClassification*)classification {
    self.classification = classification;
    [self.classificationButton setTitle:self.classification.title forState:UIControlStateNormal];
    NSLog(@"兼职：更改类别为：%@", classification.title);
    NSLog(@"兼职：当前数据，类型：%@，类别：%@", (self.type ? @"全职" : @"兼职"), self.classification.title);
    
    // 数据获取
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.jobList = [ICJobList loadJobListWithType:self.type classification:self.classification];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.jobList == nil) {
                [self.HUD hide:YES];
                [[[UIAlertView alloc]initWithTitle:@"数据载入错误！"
                                           message:@"请检查您的网络连接后重试"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil]show];
            } else {
                [self.tableView reloadData];
                [self.HUD hide:YES];
                NSLog(@"兼职：工作列表数据载入成功");
            }
        });
    });
}

- (void)loginViewController:(ICLoginViewController *)loginViewContrller
                       user:(ICUser *)user
                   didLogin:(BOOL)success {
    if (!success) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
