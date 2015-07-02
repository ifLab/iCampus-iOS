//
//  KMGradeVC.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-8-23.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMGradeVC.h"
#import "SVProgressHUD.h"
#import "KMGradeResultTVC.h"
#import "KMGradeModel.h"
#import "ICLoginViewController.h"
#import "ICUser.h"
#import "MobClick.h"

#define KMTableViewWidth 280.0f
#define KMTableViewHeight 200.0f

#define KMToGradeResultVC @"to_result_vc"

@interface KMGradeVC () <UITableViewDataSource, UITableViewDelegate, KMGradeModelDelegate, KMGradeModelResultDelegate, ICLoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *semesterLabel;
@property (weak, nonatomic) IBOutlet UILabel *catLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) UIView *initialCoverView;

@property (strong, nonatomic) KMGradeModel *model;
@property (nonatomic) int partCount;
@property (nonatomic) KMGradeModelPart currentPart;

@property (strong, nonatomic) NSMutableDictionary *selectedDict;

@property (weak, nonatomic) UILabel *currentEditingLabel;

@property (strong, nonatomic) UIControl *coverView;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic) BOOL firstAppear;

@end

@implementation KMGradeVC

- (UIView *)initialCoverView
{
    if (!_initialCoverView) {
        _initialCoverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _initialCoverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        aiv.frame = _initialCoverView.bounds;
        [aiv startAnimating];
        [_initialCoverView addSubview:aiv];
    }
    return _initialCoverView;
}

- (NSMutableDictionary *)selectedDict
{
    if (!_selectedDict) {
        _selectedDict = [@{} mutableCopy];
    }
    return _selectedDict;
}

- (KMGradeModel *)model
{
    if (!_model) {
        _model = [[KMGradeModel alloc] init];
        _model.delegate = self;
        _model.resultDelegate = self;
    }
    return _model;
}

- (UIControl *)coverView
{
    if (!_coverView) {
        _coverView = [[UIControl alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _coverView.alpha = 0;
        [_coverView addTarget:self action:@selector(dismissPopupTableView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        const CGFloat width = KMTableViewWidth;
        const CGFloat height = KMTableViewHeight;
        
        CGSize screenFrame = [[UIScreen mainScreen] bounds].size;
        
        CGRect frame = CGRectMake((screenFrame.width - width) / 2, height / 2, width, height);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        
        _tableView.rowHeight = height / 4;
        
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5.0;
        _tableView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0].CGColor;
        _tableView.layer.shadowOffset = CGSizeMake(0, 0);
        _tableView.layer.shadowRadius = 5.0;
        _tableView.layer.shadowOpacity = 0.4;
        _tableView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds cornerRadius:5.0f].CGPath;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstAppear = YES;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToPopup:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    self.view.gestureRecognizers = @[swipeGesture];
    
    _submitButton.layer.cornerRadius = 2.5f;
    [_submitButton setBackgroundImage:[[UIImage imageNamed:@"ButtonNormalBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[[UIImage imageNamed:@"ButtonHighlightedBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    
    _partCount = 0;
    _currentPart = KMGradeModelPartYear;
    
    //[self.view addSubview:self.initialCoverView];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    
    [self.model years];
    [self.model semesters];
    [self.model categories];
    
    [MobClick beginLogPageView:@"成绩查询模块"];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!ICCurrentUser && self.firstAppear) {
        self.firstAppear = false;
        [self performSegueWithIdentifier:@"IC_GRADE_TO_LOGIN" sender:self];
    }
}

- (void)swipeToPopup:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectYear:(UIButton *)sender
{
    _currentEditingLabel = _yearLabel;
    _currentPart = KMGradeModelPartYear;
    [self showPupupTableView:sender];
}

- (IBAction)selectSemester:(UIButton *)sender
{
    _currentEditingLabel = _semesterLabel;
    _currentPart = KMGradeModelPartSemester;
    [self showPupupTableView:sender];
}

- (IBAction)selectCategory:(UIButton *)sender
{
    _currentEditingLabel = _catLabel;
    _currentPart = KMGradeModelPartCategory;
    [self showPupupTableView:sender];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    switch (_currentPart) {
        case KMGradeModelPartYear:
            count = [[self.model years] count];
            break;
        case KMGradeModelPartSemester:
            count = [[self.model semesters] count];
            break;
        case KMGradeModelPartCategory:
            count = [[self.model categories] count];
            break;
            
        default:
            count = 0;
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.textColor = [UIColor colorWithRed:105/255.0 green:175/255.0 blue:75/255.0 alpha:1.0];
    }
    
    NSArray *currentList = nil;
    switch (_currentPart) {
        case KMGradeModelPartYear:
            currentList = [self.model years];
            break;
        case KMGradeModelPartSemester:
            currentList = [self.model semesters];
            break;
        case KMGradeModelPartCategory:
            currentList = [self.model categories];
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = (NSString *)currentList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentEditingLabel.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self dismissPopupTableView:_coverView];
}

- (void)showPupupTableView:(UIButton *)sender
{
    [self.navigationController.view addSubview:self.coverView];
    
    [self.coverView addSubview:self.tableView];
    
    const CGFloat width = KMTableViewWidth;
    const CGFloat height = KMTableViewHeight;
    
    CGSize screenFrame = [[UIScreen mainScreen] bounds].size;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:kNilOptions
                     animations:^{
                         _coverView.alpha = 1.0;
                         _tableView.frame = CGRectMake((screenFrame.width - width) / 2, (screenFrame.height - height) / 2, width, height);
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)dismissPopupTableView:(UIControl *)sender
{
    const CGFloat width = KMTableViewWidth;
    const CGFloat height = KMTableViewHeight;
    
    CGSize screenFrame = [[UIScreen mainScreen] bounds].size;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:kNilOptions
                     animations:^{
                         _coverView.alpha = 0;
                         _tableView.frame = CGRectMake((screenFrame.width - width) / 2, height / 2, width, height);
                     }
                     completion:^(BOOL finished){
                         [self.tableView removeFromSuperview];
                         _tableView = nil;
                         [self.coverView removeFromSuperview];
                         _coverView = nil;
                     }];
}

#pragma mark - KM Grade Model delegate

- (void)KMGradeModelDidFailFetchingWithPart:(KMGradeModelPart)part
{
    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.initialCoverView.alpha = 0.0f;
                             }
                             completion:^(BOOL success){
                                 [self.initialCoverView removeFromSuperview];
                             }
             ];
        });
    });
    */
}

- (void)KMGradeModelDidFinishFethingWithPart:(KMGradeModelPart)part
{
    _partCount++;
    
    if (_partCount > 1) {
        _partCount = 0;
        /*
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.initialCoverView.alpha = 0.0f;
                         }
                         completion:^(BOOL success){
                             [self.initialCoverView removeFromSuperview];
                         }];
        */
        [SVProgressHUD dismiss];
    }
}

- (IBAction)startSearch:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"正在查询" maskType:SVProgressHUDMaskTypeBlack];
    [self.model gradesWithYear:_yearLabel.text
                      semester:_semesterLabel.text
                      category:_catLabel.text];
}

- (void)KMGradeResultDidFinsihFetchingData
{
    if (self.model.grades.count > 0) {
        [SVProgressHUD showSuccessWithStatus:@"查询成功"];
        [self performSegueWithIdentifier:KMToGradeResultVC sender:self];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"未找到相应结果"];
    }
}

- (void)KMGradeResultDidFailFetchingData
{
    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:KMToGradeResultVC]) {
        KMGradeResultTVC *resultVC = segue.destinationViewController;
        if (self.model.grades.count > 0) {
            resultVC.grades = [self.model.grades copy];
        }
    } else if ([segue.identifier isEqualToString:@"IC_GRADE_TO_LOGIN"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ICLoginViewController *loginViewController = (ICLoginViewController *)navigationController.topViewController;
        loginViewController.delegate = self;
    }
}

- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [MobClick endLogPageView:@"成绩查询模块"];
}

- (void)loginViewController:(ICLoginViewController *)loginViewContrller user:(ICUser *)user didLogin:(BOOL)success {
    if (success) {
        [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
        _model = nil;
        [self.model years];
        [self.model semesters];
        [self.model categories];
    } else {
        [self dismiss:self];
    }
}

@end
