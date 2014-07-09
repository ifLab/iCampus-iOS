//
//  ICJobNewJobTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-4-1.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobNewJobTableViewController.h"
#import "ICJob.h"
#import "ICUser.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface ICJobNewJobTableViewController ()

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *contactNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactQQTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property ICJobClassificationList *classificationList;
@property NSMutableArray *typeArray;
@property NSMutableArray *classificationArray;
@property NSMutableDictionary *job;

@end

@implementation ICJobNewJobTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置代理
    self.titleTextView.delegate = self;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.contactNameTextField.delegate = self;
    self.contactPhoneTextField.delegate = self;
    self.contactEmailTextField.delegate = self;
    self.contactQQTextField.delegate = self;
    
    // 为键盘添加隐藏按钮
    void (^addTopView)(UIView *) = ^(UIView *view) {
        UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        UIBarButtonItem *flexBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *dismissKeyBoardButton;
        topView.backgroundColor = [UIColor whiteColor];
        if (view.class == [UITextField class]) {
            ((UITextField *)view).inputAccessoryView = topView;
            dismissKeyBoardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(dismissKeyBoard)];
        } else if (view.class == [UITextView class]) {
            ((UITextView *)view).inputAccessoryView = topView;
            dismissKeyBoardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(dismissKeyBoard)];
        }
        NSArray *buttonsArray = @[flexBtn, dismissKeyBoardButton];
        topView.items = buttonsArray;
    };
    addTopView(self.contactPhoneTextField);
    addTopView(self.contactQQTextField);
    addTopView(self.descriptionTextView);
    
    // 获取并设置工作类型选择器
    self.pickerView.hidden = 1;
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.classificationList = [ICJobClassificationList loadJobClassificationList];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *partTimeString;
            NSString *fullTimeString;
            NSString *okString;
            NSString *loadFailedString;
            NSString *retryString;
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *currentLanguage = [languages objectAtIndex:0];
            if ([currentLanguage isEqualToString:@"zh-Hans"]) {
                partTimeString = @"兼职";
                fullTimeString = @"全职";
                okString = @"好";
                loadFailedString = @"加载失败";
                retryString = @"请检查您的网络连接后重试。";
            } else {
                partTimeString = @"Part-time";
                fullTimeString = @"Full-time";
                okString = @"OK";
                loadFailedString = @"Loading failed";
                retryString = @"Please check you network connection and try again.";
            }
            if (self.classificationList == nil) {
                [self.HUD hide:YES];

                [[[UIAlertView alloc]initWithTitle:loadFailedString
                                           message:retryString
                                          delegate:self
                                 cancelButtonTitle:okString
                                 otherButtonTitles:nil]show];
            } else {
                self.typeArray = [NSMutableArray arrayWithArray:@[partTimeString, fullTimeString]];
                self.classificationArray = [[NSMutableArray alloc] init];
                for (ICJobClassification *classification in self.classificationList.jobClassificationList) {
                    if (classification.index != 0) {
                        [self.classificationArray addObject:classification.title];
                    }
                }
                [self.pickerView reloadAllComponents];
                self.pickerView.hidden = 0;
                [self.HUD hide:YES];
            }
        });
    });

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    BOOL __block failed = NO;
    typedef BOOL (^TextViewTestingBlock)(UIView *);
    typedef void (^SetSuperViewWithSubViewBlock)(UIView *);
    TextViewTestingBlock isBlank = ^(UIView *view) {
        if (view.class == [UITextView class]) {
            return (BOOL)!((UITextView *)view).text.length;
        } else if (view.class == [UITextField class]) {
            return (BOOL)!((UITextField *)view).text.length;
        }
        return NO;
    };
    SetSuperViewWithSubViewBlock highlight = ^(UIView *view) {
        view.superview.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
        failed = YES;
    };
    SetSuperViewWithSubViewBlock reset = ^(UIView *view) {
        view.superview.backgroundColor = [UIColor clearColor];
    };
    SetSuperViewWithSubViewBlock testHighlight = ^(UIView *view) {
        if (isBlank(view)) {
            highlight(view);
        } else {
            reset(view);
        }
    };
    testHighlight(self.titleTextView);
    testHighlight(self.descriptionTextView);
    testHighlight(self.contactNameTextField);
    if (isBlank(self.contactEmailTextField) && isBlank(self.contactPhoneTextField) && isBlank(self.contactQQTextField)) {
        highlight(self.contactEmailTextField);
        highlight(self.contactPhoneTextField);
        highlight(self.contactQQTextField);
    } else {
        reset(self.contactPhoneTextField);
        reset(self.contactEmailTextField);
        reset(self.contactQQTextField);
    }
    if (failed) {
        return;
    }
    
    NSString *mod = [NSString stringWithFormat:@"%d", ([self.pickerView selectedRowInComponent:0] == 1 ? 1 : 2)];
    NSInteger classificationRow = [self.pickerView selectedRowInComponent:1];
    NSString *classificationTitle = (self.classificationArray)[classificationRow];
    NSString *typeid;
    for (ICJobClassification *classification in self.classificationList.jobClassificationList) {
        if (classificationTitle == classification.title) {
            typeid = [NSString stringWithFormat:@"%d", (int)classification.index];
            break;
        }
    }
    if (self.contactPhoneTextField.text.length == 0) self.contactPhoneTextField.text = @"";
    if (self.contactEmailTextField.text.length == 0) self.contactEmailTextField.text = @"";
    if (self.contactQQTextField.text.length == 0) self.contactQQTextField.text = @"";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (!ICCurrentUser) {
        return;
    }
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    NSString *failedString;
    NSString *retryString;
    NSString *okString;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        failedString = @"发布失败";
        retryString = @"请检查您的网络连接后重试。";
        okString = @"好";
    } else {
        failedString = @"Publish failed";
        retryString = @"Please check you network connection and try again.";
        okString = @"OK";
    }
    AFHTTPRequestOperation *operation = [manager POST:@"http://m.bistu.edu.cn/newapi/job_add.php"
                                           parameters:@{@"title": self.titleTextView.text ? self.titleTextView.text : @"",
                                                        @"mod": mod,
                                                        @"typeid": typeid,
                                                        @"description": self.descriptionTextView.text,
                                                        @"location": @"",
                                                        @"qualifications": @"",
                                                        @"salary": @"",
                                                        @"company": @"",
                                                        @"contactName": self.contactNameTextField.text,
                                                        @"contactPhone": self.contactPhoneTextField.text,
                                                        @"contactEmail": self.contactEmailTextField.text,
                                                        @"contactQQ": self.contactQQTextField.text,
                                                        @"userid": ICCurrentUser.ID
//                                                        @"Authorization": [NSString stringWithFormat:@"Bearer %@", ICCurrentUser.token]
                                                        }
                            constructingBodyWithBlock:nil
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  [self.HUD hide:YES];
                                                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
                                                  NSInteger jobID = [json[@"id"] intValue];
                                                  NSString *explanation;
                                                  explanation = json[@"message"];
                                                  if (jobID == 0) {
                                                      [[[UIAlertView alloc]initWithTitle:failedString
                                                                                 message:retryString
                                                                                delegate:nil
                                                                       cancelButtonTitle:okString
                                                                       otherButtonTitles:nil]show];
                                                  } else if (jobID < 0) {
                                                      [[[UIAlertView alloc]initWithTitle:@"对不起，您的账户被锁定！"
                                                                                 message:explanation
                                                                                delegate:nil
                                                                       cancelButtonTitle:okString
                                                                       otherButtonTitles:nil]show];
                                                  } else {
                                                      [self.delegate needReloadData];
                                                      [self dismissViewControllerAnimated:YES
                                                                               completion:nil];
                                                  }
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  [self.HUD hide:YES];
                                                  [[[UIAlertView alloc]initWithTitle:failedString
                                                                             message:retryString
                                                                            delegate:nil
                                                                   cancelButtonTitle:okString
                                                                   otherButtonTitles:nil]show];
                                              }];
    [operation start];
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

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

// 键盘隐藏
- (void)dismissKeyBoard {
    [self.titleTextView resignFirstResponder];
    [self.contactPhoneTextField resignFirstResponder];
    [self.contactQQTextField resignFirstResponder];
    [self.contactNameTextField resignFirstResponder];
    [self.contactEmailTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyBoard];
    return YES;
}

// 检测并限制工作标题长度
- (BOOL)       textView:(UITextView*)textView
shouldChangeTextInRange:(NSRange)range
        replacementText:(NSString*)text {
    if(1 == range.length) {
        //允许在字符达到上限后退格
        return YES;
    }
    if([text isEqualToString:@"\n"]) {
        //按下return键时隐藏键盘
        [textView resignFirstResponder];
        return NO;
    } else {
        if([textView.text length] < 14) {
            //判断字符个数
            return YES;
        }
    }
    return NO;
}

// 分类选择器数据设置
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [self.typeArray count];
    } else {
        return [self.classificationArray count];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    if (component == 0) {
        return (self.typeArray)[row];
    } else {
        return (self.classificationArray)[row];
    }
    return nil;
}

@end
