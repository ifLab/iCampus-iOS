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

@end

@implementation ICJobListTableViewController

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
    NSDictionary *attributesDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor whiteColor],NSForegroundColorAttributeName,
                                   [UIFont systemFontOfSize:16.0],NSFontAttributeName, nil];
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
    } else if ([segue.identifier isEqualToString:@"IC_JOB_LIST_TO_CLASSIFICATION"]) {
        // 跳转到分类列表
        UINavigationController *navigationController = segue.destinationViewController;
        ICJobClassificationListTableViewController *controller = (ICJobClassificationListTableViewController*) navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:nil]) {}
}

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

- (void)disappearSegmentedControl {
    self.segmentedControl.hidden = YES;
}
- (void)appearSegmentedControl {
    self.segmentedControl.hidden = NO;
}

@end
