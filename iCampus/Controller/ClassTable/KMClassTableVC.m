//
//  KMClassTableVC.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-8-23.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMClassTableVC.h"
#import "KMClassTableModel.h"
#import "KMClassTableDetailVC.h"
#import "SVProgressHUD.h"

@interface KMClassTableVC () <KMClassTableModelDelegate>

@property (strong, nonatomic) KMClassTableModel *model;

@property (weak, nonatomic) IBOutlet UIScrollView *centerScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *leftScrollView;

@property (strong, nonatomic) UIControl *initialCoverView;

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSArray *normalBarItems;
@property (strong, nonatomic) NSArray *selectingBarItems;

@end

@implementation KMClassTableVC

- (NSArray *)normalBarItems
{
    if (!_normalBarItems) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"日期选择"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(toggleDatePicker:)];
        _normalBarItems = @[item];
    }
    return _normalBarItems;
}

- (NSArray *)selectingBarItems
{
    if (!_selectingBarItems) {
        UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(cancleSelecting:)];
        UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(submitSelecting:)];
        _selectingBarItems = @[cancleItem, submitItem];
    }
    return _selectingBarItems;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        _datePicker.layer.shadowColor = [[UIColor blackColor] CGColor];
        _datePicker.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        _datePicker.layer.shadowOpacity = 0.2;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        CGSize size = _datePicker.bounds.size;
        _datePicker.center = CGPointMake(size.width / 2.0, 0);
        _datePicker.alpha = 0.0f;
    }
    return _datePicker;
}

- (KMClassTableModel *)model
{
    if (!_model) {
        _model = [[KMClassTableModel alloc] init];
        _model.delegate = self;
    }
    return _model;
}

- (UIView *)initialCoverView
{
    if (!_initialCoverView) {
        _initialCoverView = [[UIControl alloc] initWithFrame:self.view.bounds];
        _initialCoverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [_initialCoverView addTarget:self action:@selector(cancleSelecting:) forControlEvents:UIControlEventTouchUpInside];
        
        /*
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.frame = _initialCoverView.bounds;
        [_initialCoverView addSubview:loadingView];
        [loadingView startAnimating];
        */
    }
    return _initialCoverView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = self.normalBarItems;
    
    self.topScrollView.userInteractionEnabled = NO;
    self.leftScrollView.userInteractionEnabled = NO;
    
    [self setupTopScrollViewContent];
    [self setupLeftScrollViewContent];
    //[self setupCenterScrollViewLines];
    
    //[self.model fetchWeeklyCoursesWithDate:@"2014-3-30"];
    [self.model fetchWeeklyCoursesWithDate:nil];
    
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.view addSubview:self.initialCoverView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTopScrollViewContent
{
    CGFloat currX = 0.0f;
    int index = 0;
    NSArray *titles = @[NSLocalizedString(@"Mon", nil),
                        NSLocalizedString(@"Tues", nil),
                        NSLocalizedString(@"Wed", nil),
                        NSLocalizedString(@"Thur", nil),
                        NSLocalizedString(@"Fri", nil),
                        NSLocalizedString(@"Sat", nil),
                        NSLocalizedString(@"Sun", nil),];
    for (NSString *title in titles) {
        CGRect frame = CGRectMake(currX, 0, cellWidth, columnWidth);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        if (index % 2 == 0) {
            label.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
        } else {
            label.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        }
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        [self.topScrollView addSubview:label];
        currX += cellWidth + 1;
        index++;
    }
    self.topScrollView.contentSize = CGSizeMake(currX, columnWidth);
}

- (void)setupLeftScrollViewContent
{
    CGFloat currY = 0.0f;
    int index = 0;
    NSArray *titles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14"];
    for (NSString *title in titles) {
        CGRect frame = CGRectMake(0, currY, columnWidth, cellHeight);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        if (index % 2 == 0) {
            label.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
        } else {
            label.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        }
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        [self.leftScrollView addSubview:label];
        currY += cellHeight + 1;
        index++;
    }
    self.leftScrollView.contentSize = CGSizeMake(columnWidth, currY);
}

- (void)setupCenterScrollViewLines
{
    for (int i = 0; i <= 7; i++) {
        CGRect frame = CGRectMake(i * cellWidth + i - 1, 0, 1, self.leftScrollView.contentSize.height);
        UIView *line = [[UIView alloc] initWithFrame:frame];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.centerScrollView addSubview:line];
    }
    
    for (int i = 0; i <= 14; i++) {
        CGRect frame = CGRectMake(0, i * cellHeight + i - 1, self.topScrollView.contentSize.width, 1);
        UIView *line = [[UIView alloc] initWithFrame:frame];
        line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        if (i == 5 || i == 10) { // noon and night
            line.backgroundColor = [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0];
        }
        [self.centerScrollView addSubview:line];
    }
    
    self.centerScrollView.contentSize = CGSizeMake(_topScrollView.contentSize.width, _leftScrollView.contentSize.height);
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGRect)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)populateCellWithCourse:(KMCourseObject *)course
{
    NSInteger x = course.week.integerValue - 1;
    NSInteger y = course.orderInDay.integerValue - 1;
    NSInteger count = course.lengthInLesson.integerValue;
    CGRect cellFrame = CGRectMake(x * cellWidth + x, y * cellHeight + y, cellWidth, cellHeight*count + count - 1);
    UIButton *cellView = [[UIButton alloc] initWithFrame:cellFrame];
    cellView.tag = [self.model.weeklyCourses indexOfObject:course];
    [cellView addTarget:self action:@selector(handleCellViewTapAction:) forControlEvents:UIControlEventTouchUpInside];
    cellView.clipsToBounds = YES;
    [cellView setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:105/255.0 green:175/255.0 blue:75/255.0 alpha:1.0] size:cellView.bounds] forState:UIControlStateNormal];
    [cellView setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:72/255.0 green:142/255.0 blue:42/255.0 alpha:1.0] size:cellView.bounds] forState:UIControlStateHighlighted];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, (cellHeight*count/5)*3)];
    name.numberOfLines = 0;
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont systemFontOfSize:13.0];
    name.textAlignment = NSTextAlignmentCenter;
    name.text = course.courseName;
    [cellView addSubview:name];
    
    UILabel *room = [[UILabel alloc] initWithFrame:CGRectMake(0, (cellHeight*count/5)*3, cellWidth, (cellHeight*count/5)*2)];
    room.numberOfLines = 0;
    room.textColor = [UIColor whiteColor];
    room.font = [UIFont systemFontOfSize:13.0];
    room.textAlignment = NSTextAlignmentCenter;
    room.text = course.teacherName;
    [cellView addSubview:room];
    
    [self.centerScrollView addSubview:cellView];
}

- (void)handleCellViewTapAction:(UIButton *)sender
{
    
    // class_table_detail_vc
    KMClassTableDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"class_table_detail_vc"];
    detailVC.course = (KMCourseObject *)self.model.weeklyCourses[sender.tag];
    [detailVC willMoveToParentViewController:self.navigationController];
    [self.navigationController addChildViewController:detailVC];
    [self.navigationController.view addSubview:detailVC.view];
    [detailVC didMoveToParentViewController:self.navigationController];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kCenterScrollViewTag) {
        CGPoint topOffset = self.topScrollView.contentOffset;
        topOffset.x = scrollView.contentOffset.x;
        [self.topScrollView setContentOffset:topOffset];
        
        CGPoint leftOffset = self.leftScrollView.contentOffset;
        leftOffset.y = scrollView.contentOffset.y;
        [self.leftScrollView setContentOffset:leftOffset];
    }
}

#pragma mark - Class Table delegate

- (void)KMClassTableDidFinishLoadingCoursesData:(NSMutableArray *)courses
{
    if (self.model.weeklyCourses.count > 0) {
        [SVProgressHUD showSuccessWithStatus:@"获取课表成功"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"当前无可用课表"];
    }
    //[self setupTopScrollViewContent];
    //[self setupLeftScrollViewContent];
    [self setupCenterScrollViewLines];
    
    for (KMCourseObject *course in courses) {
        [self populateCellWithCourse:course];
    }
    
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
}

- (void)KMClassTableDidFailLoadingCoursesData:(NSDictionary *)errorInfo
{
    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
}

#pragma mark - Pick date

- (void)submitSelecting:(UIBarButtonItem *)sender
{
    self.navigationItem.rightBarButtonItems = self.normalBarItems;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    [self.model fetchWeeklyCoursesWithDate:[formatter stringFromDate:self.datePicker.date]];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    
    [self.datePicker removeFromSuperview];
    _datePicker = nil;
    
    [self.initialCoverView removeFromSuperview];
    _initialCoverView = nil;
}

- (void)cancleSelecting:(id)sender
{
    self.navigationItem.rightBarButtonItems = nil;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGSize size = self.datePicker.bounds.size;
                         self.datePicker.center = CGPointMake(size.width / 2.0, 0);
                         self.datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.navigationItem.rightBarButtonItems = self.normalBarItems;
                             
                             [UIView animateWithDuration:0.3
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  self.initialCoverView.alpha = 0.0f;
                                              }
                                              completion:^(BOOL success){
                                                  [self.datePicker removeFromSuperview];
                                                  _datePicker = nil;
                                                  
                                                  [self.initialCoverView removeFromSuperview];
                                                  _initialCoverView = nil;
                                              }];
                         }
                     }];
}

- (void)toggleDatePicker:(UIBarButtonItem *)sender
{
    self.navigationItem.rightBarButtonItems = nil;
    
    if (_initialCoverView == nil) {
        
        [self.initialCoverView addSubview:self.datePicker];
        [self.view addSubview:self.initialCoverView];
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGSize size = self.datePicker.bounds.size;
                             self.datePicker.alpha = 1.0f;
                             self.datePicker.center = CGPointMake(size.width / 2.0, size.height / 2.0);
                         }
                         completion:^(BOOL finished){
                             self.navigationItem.rightBarButtonItems = self.selectingBarItems;
                         }];
    }
}


- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

