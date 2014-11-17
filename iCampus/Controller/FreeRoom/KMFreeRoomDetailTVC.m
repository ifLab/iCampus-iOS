//
//  KMFreeRoomDetailTVC.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14/10/20.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMFreeRoomDetailTVC.h"
#import "KMFreeRoomsModel.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD.h"

@interface KMFreeRoomDetailTVC ()

@property (copy, nonatomic) NSArray *data;
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (strong, nonatomic) UIControl *initialCoverView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSArray *normalBarItems;
@property (strong, nonatomic) NSArray *selectingBarItems;

@end

@implementation KMFreeRoomDetailTVC

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
    self.tableView.rowHeight = 56;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    __weak KMFreeRoomDetailTVC *weakSelf = self;
    weakSelf.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        weakSelf.data = [KMFreeRoomsModel getRoomDetailWithRoomID:weakSelf.roomCode atDate:[formatter stringFromDate:[NSDate date]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.data == nil) {
                [weakSelf.HUD hide:YES];
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
                [weakSelf.HUD hide:YES];
                [self.tableView reloadData];
            }
        });
    });
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Course"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Course"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld节", (long)indexPath.row + 1];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    KMRoomDetail *currObj = (KMRoomDetail *)self.data[indexPath.row];
    if (currObj.order == indexPath.row + 1) {
        cell.backgroundColor = [[UIColor alloc] initWithRed:111/255.0 green:175/255.0 blue:66/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@", currObj.courseTeacher, currObj.courseName];
    } else {
        cell.backgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        cell.textLabel.textColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
        cell.detailTextLabel.text = @" ";
    }
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KMRoomDetail *currObj = (KMRoomDetail *)self.data[indexPath.row];
    if (currObj.courseName != nil) {
        [[[UIAlertView alloc]initWithTitle:currObj.courseName
                                   message:[NSString stringWithFormat:@"开课学院：%@\n授课教师：%@\n学分：%@", currObj.courseCollage, currObj.courseTeacher, currObj.courseCredits]
                                  delegate:self
                         cancelButtonTitle:@"确认"
                         otherButtonTitles:nil]show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)submitSelecting:(UIBarButtonItem *)sender
{
    self.navigationItem.rightBarButtonItems = self.normalBarItems;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.data = [KMFreeRoomsModel getRoomDetailWithRoomID:self.roomCode atDate:[formatter stringFromDate:self.datePicker.date]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.data == nil) {
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
                [self.HUD hide:YES];
                [self.tableView reloadData];
            }
        });
    });
    
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
