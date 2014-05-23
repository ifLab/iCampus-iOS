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
@property (weak, nonatomic) IBOutlet UITextView *locationTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
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
@property NSMutableArray *typeArray;
@property NSMutableArray *classificationArray;

@end

@implementation ICJobNewJobTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置光标颜色
    self.titleTextView.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    self.locationTextView.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    self.descriptionTextView.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    self.qualificationsTextView.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    self.salaryTextView.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    self.companyTextView.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    self.contactNameTextField.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    self.contactPhoneTextField.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    self.contactEmailTextField.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    self.contactQQTextField.tintColor = [UIColor colorWithRed:(float)20/255 green:(float)111/255 blue:(float)225/255 alpha:1.0];
    
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
    NSArray * buttonsArray = [NSArray arrayWithObjects:flexBtn, dismissKeyBoardButton, nil];
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
        ICJobClassificationList *classificationList;
        classificationList = [ICJobClassificationList loadJobClassificationList];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (classificationList == nil) {
                [self.HUD hide:YES];
                [[[UIAlertView alloc]initWithTitle:@"数据载入错误！"
                                           message:@"请检查您的网络连接后重试"
                                          delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil]show];
            } else {
                self.typeArray = [[NSMutableArray alloc] initWithObjects:@"兼职", @"全职", nil];
                self.classificationArray = [[NSMutableArray alloc] init];
                for (ICJobClassification *classification in classificationList.jobClassificationList) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    ICJob *job = [[ICJob alloc] init];
    if (/*/[self.titleTextField.text length] *
        [self.locationTextField.text length] *
        [self.descriptionTextView.text length] *
        [self.qualificationsTextView.text length] *
        [self.salaryTextView.text length] *
        [self.contactTextView.text length] *
        [self.promulgatorContactTextView.text length] != 0/*/1/**/) {
#warning 未实现数据采集处理及上传
        NSLog(@"<#string#>");
        
//        //第一步，创建URL
//        NSURL *url = [NSURL URLWithString:@"http://m.bistu.edu.cn/newapi/job_add.php"];
//        //第二步，创建请求
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
//                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                               timeoutInterval:10];
//        [request setHTTPMethod:@"POST"]; //设置请求方式为POST，默认为GET
//        [request setValue:ICCurrentUser.token
//       forHTTPHeaderField:@"Authorization"];
//        
//        NSString *str = @"type=focus-c";//设置参数
//        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:data];
//        //第三步，连接服务器
//        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str1);

//        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://jwcapp.bistu.edu.cn/upload.php"]];
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        // NSLog(@"%@",imageData);
//        AFHTTPRequestOperation *opration = [manager POST:@"http://jwcapp.bistu.edu.cn/upload.php"
//                                              parameters:nil
//                               constructingBodyWithBlock:nil
//                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
//                                                NSLog(@"%@", json);
//                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
//                                            }];
//        
//        [opration start];
//        AFHTTPRequestOperationManager *manager1 = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://m.bistu.edu.cn/newapi/secondhand_add.php"]];
//        // NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        // NSLog(@"%@",imageData);
//        AFHTTPRequestOperation *opration1 = [manager POST:@"http://m.bistu.edu.cn/newapi/secondhand_add.php"
//                                               parameters:nil
//                                constructingBodyWithBlock:nil
//                                                  success:^(AFHTTPRequestOperation *operation1, id responseObject) {
//                                                      NSDictionary *json1 = [NSJSONSerialization JSONObjectWithData:operation1.responseData
//                                                                     options:kNilOptions
//                                                                       error:nil];
//                                                      NSLog(@"%@", json1);
//                                                  } failure:^(AFHTTPRequestOperation *operation1, NSError *error) {
//                                                      NSLog(@"Error: %@ ***** %@", opration1.responseString, error);
//                                                  }];
//
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[[UIAlertView alloc]initWithTitle:@"请完整填写所有部分！"
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil, nil]show];
    }
}

- (void)     alertView:(UIAlertView *)alertView
  clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
        return [self.typeArray objectAtIndex:row];
    } else {
        return [self.classificationArray objectAtIndex:row];
    }
    return nil;
}

@end
