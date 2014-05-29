//
//  ICJobNewJobTableViewController.m
//  iCampus
//
//  Created by Jerry Black on 14-4-1.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobNewJobTableViewController.h"

@interface ICJobNewJobTableViewController ()

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *locationTextView;
@property (weak, nonatomic) IBOutlet UITextView *qualificationsTextView;
@property (weak, nonatomic) IBOutlet UITextView *salaryTextView;
@property (weak, nonatomic) IBOutlet UITextView *companyTextView;
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
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIBarButtonItem *flexBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *dismissKeyBoardButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = @[flexBtn, dismissKeyBoardButton];
    [topView setItems:buttonsArray];
    [self.locationTextView setInputAccessoryView:topView];
    [self.descriptionTextView setInputAccessoryView:topView];
    [self.qualificationsTextView setInputAccessoryView:topView];
    [self.salaryTextView setInputAccessoryView:topView];
    [self.companyTextView setInputAccessoryView:topView];
    [self.contactPhoneTextField setInputAccessoryView:topView];
    [self.contactQQTextField setInputAccessoryView:topView];
    
    // 获取并设置工作类型选择器
    self.pickerView.hidden = 1;
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.classificationList = [ICJobClassificationList loadJobClassificationList];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.classificationList == nil) {
                [self.HUD hide:YES];
                [[[UIAlertView alloc]initWithTitle:@"分类数据载入错误！"
                                           message:@"请检查您的网络连接后重试"
                                          delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil]show];
            } else {
                self.typeArray = [[NSMutableArray alloc] initWithObjects:@"兼职", @"全职", nil];
                self.classificationArray = [[NSMutableArray alloc] init];
                for (ICJobClassification *classification in self.classificationList.jobClassificationList) {
                    if (classification.index != 0) {
                        [self.classificationArray addObject:classification.title];
                    }
                }
                [self.pickerView reloadAllComponents];
                self.pickerView.hidden = 0;
                [self.HUD hide:YES];
                NSLog(@"兼职：分类选择器数据载入成功，并设置完成");
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
    if ([self.titleTextView.text length] == 0) {
        self.titleTextView.superview.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
    } else {
        self.titleTextView.superview.backgroundColor = [UIColor clearColor];
    }
    if ([self.descriptionTextView.text length] == 0) {
        self.descriptionTextView.superview.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
    } else {
        self.descriptionTextView.superview.backgroundColor = [UIColor clearColor];
    }
    /*
    if ([self.locationTextView.text length] == 0) {
        self.locationTextView.superview.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
    } else {
        self.locationTextView.superview.backgroundColor = [UIColor clearColor];
    }
    if ([self.qualificationsTextView.text length] == 0) {
        self.qualificationsTextView.superview.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
    } else {
        self.qualificationsTextView.superview.backgroundColor = [UIColor clearColor];
    }
    if ([self.salaryTextView.text length] == 0) {
        self.salaryTextView.superview.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
    } else {
        self.salaryTextView.superview.backgroundColor = [UIColor clearColor];
    } //*/
    if ([self.contactNameTextField.text length] == 0) {
        self.contactNameTextField.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
    } else {
        self.contactNameTextField.backgroundColor = [UIColor clearColor];
    }
    if ([self.contactPhoneTextField.text length] +
        [self.contactEmailTextField.text length] +
        [self.contactQQTextField.text length] == 0) {
        self.contactPhoneTextField.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
        self.contactEmailTextField.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
        self.contactQQTextField.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];
    } else {
        self.contactPhoneTextField.backgroundColor = [UIColor clearColor];
        self.contactEmailTextField.backgroundColor = [UIColor clearColor];
        self.contactQQTextField.backgroundColor = [UIColor clearColor];
    }
    
    if ([self.titleTextView.text length] *
        [self.descriptionTextView.text length] *
//        [self.locationTextView.text length] *
//        [self.qualificationsTextView.text length] *
//        [self.salaryTextView.text length] *
        [self.contactNameTextField.text length] == 0) {
        [[[UIAlertView alloc]initWithTitle:@"信息不完整！"
                                   message:@"请确认已正确填写所有必填项后再提交"
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil]show];
    } else if ([self.contactPhoneTextField.text length] +
               [self.contactEmailTextField.text length] +
               [self.contactQQTextField.text length] == 0) {
        [[[UIAlertView alloc]initWithTitle:@"信息不完整！"
                                   message:@"请至少填写一种联系方式"
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil]show];
    } else {
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
        if (self.companyTextView.text.length == 0) self.companyTextView.text = @"空";
        if (self.contactPhoneTextField.text.length == 0) self.contactPhoneTextField.text = @"空";
        if (self.contactEmailTextField.text.length == 0) self.contactEmailTextField.text = @"空";
        if (self.contactQQTextField.text.length == 0) self.contactQQTextField.text = @"空";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        if (!ICCurrentUser) {
            NSLog(@"兼职：用户尚未登录");
            return;
        }
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view
                                        animated:YES];
        AFHTTPRequestOperation *operation = [manager POST:@"http://m.bistu.edu.cn/newapi/job_add.php"
                                               parameters:@{@"title": self.titleTextView.text,
                                                            @"mod": mod,
                                                            @"typeid": typeid,
                                                            @"description": self.descriptionTextView.text,
//                                                            @"location": self.locationTextView.text,
//                                                            @"qualifications": self.qualificationsTextView.text,
//                                                            @"salary": self.salaryTextView.text,
//                                                            @"company": self.companyTextView.text,
                                                            @"location": @"空",
                                                            @"qualifications": @"空",
                                                            @"salary": @"空",
                                                            @"company": @"空",
                                                            @"contactName": self.contactNameTextField.text,
                                                            @"contactPhone": self.contactPhoneTextField.text,
                                                            @"contactEmail": self.contactEmailTextField.text,
                                                            @"contactQQ": self.contactQQTextField.text,
                                                            @"userid": ICCurrentUser.ID,
//                                                            @"Authorization": [NSString stringWithFormat:@"Bearer %@", ICCurrentUser.token]
                                                            }
                                constructingBodyWithBlock:nil
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      [self.HUD hide:YES];
                                                      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:kNilOptions
                                                                       error:nil];
                                                      NSInteger jobID = [json[@"id"] intValue];
                                                      if (jobID == 0) {
                                                          NSLog(@"兼职：上传失败");
                                                          [[[UIAlertView alloc]initWithTitle:@"上传失败！"
                                                                                     message:@"请检查您的网络连接后重试"
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"确定"
                                                                           otherButtonTitles:nil]show];
                                                      } else {
                                                          NSLog(@"兼职：上传成功，ID：%ld", (long)jobID);
                                                          [[[UIAlertView alloc]initWithTitle:@"上传成功！"
                                                                                     message:nil
                                                                                    delegate:self
                                                                           cancelButtonTitle:@"确定"
                                                                           otherButtonTitles:nil]show];
                                                          [self.delegate needReloadData];
                                                      }
                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      [self.HUD hide:YES];
                                                      NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                                      [[[UIAlertView alloc]initWithTitle:@"上传失败！"
                                                                                 message:@"请检查您的网络连接后重试"
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"确定"
                                                                       otherButtonTitles:nil]show];
                                                  }];
        [operation start];

//        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    [self.locationTextView resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
    [self.qualificationsTextView resignFirstResponder];
    [self.salaryTextView resignFirstResponder];
    [self.companyTextView resignFirstResponder];
    [self.contactPhoneTextField resignFirstResponder];
    [self.contactQQTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.contactNameTextField resignFirstResponder];
    [self.contactEmailTextField resignFirstResponder];
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
