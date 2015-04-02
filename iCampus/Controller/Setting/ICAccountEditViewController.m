//
//  ICAccountEditViewController.m
//  iCampus
//
//  Created by Darren Liu on 14-5-22.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICAccountEditViewController.h"
#import "AFNetworking.h"
#import "ICUser.h"
#import "MBProgressHUD.h"

@interface ICAccountEditViewController ()

- (IBAction)cancel:(id)sender;
- (IBAction)update:(id)sender;

@end

@implementation ICAccountEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (ICCurrentUser) {
        self.QQDetailTextField.text = ICCurrentUser.QQ;
        self.WeChatDetailTextField.text = ICCurrentUser.WeChat;
        self.mobileDetailTextField.text = ICCurrentUser.mobile;
        self.emailDetailTextField.text = ICCurrentUser.email;
    }
}

- (IBAction)cancel:(id)sender {
    [self.delegate accountEditViewController:self
                        didDismissWithStatus:ICAccountEditViewControllerDismissStatusCancel];
}

- (void)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (IBAction)update:(id)sender {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSInteger __block result = 0;
     AFHTTPRequestOperation *operation = [manager POST:@"http://m.bistu.edu.cn/userinfomod.php"
                                            parameters:@{@"userid":ICCurrentUser.ID,
                                                         @"qq":self.QQDetailTextField.text,
                                                         @"wechat":[self.WeChatDetailTextField.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                         @"mobile":self.mobileDetailTextField.text,
                                                         @"email":[self.emailDetailTextField.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]}
                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   result = [[[NSString alloc] initWithData:responseObject
                                                                                   encoding:NSUTF8StringEncoding]
                                                             integerValue];
                                                   NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   result = 2;
                                               }];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [operation waitUntilFinished];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result == 1 || result == 0) { // It's a logic error, but it works now...
                [HUD hide:YES];
                if (self.delegate && [self.delegate conformsToProtocol:@protocol(ICAccoutEditViewControllerDelegate)]) {
                    [self.delegate accountEditViewController:self
                                        didDismissWithStatus:ICAccountEditViewControllerDismissStatusDone];
                }
            } else if (result == 2) {
                [HUD hide:YES];
                [[[UIAlertView alloc] initWithTitle:@"错误" message:@"现在无法修改信息，请检查您的网络连接。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
                self.navigationItem.leftBarButtonItem.enabled = YES;
                self.navigationItem.rightBarButtonItem.enabled = YES;
            } else {
                [HUD hide:YES];
                [[[UIAlertView alloc] initWithTitle:@"错误" message:@"未知错误。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
                self.navigationItem.leftBarButtonItem.enabled = YES;
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            /* else if (result == 0) {
                [HUD hide:YES];
                [[[UIAlertView alloc] initWithTitle:@"错误" message:@"服务端状态异常。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
                self.navigationItem.leftBarButtonItem.enabled = YES;
                self.navigationItem.rightBarButtonItem.enabled = YES;
            } */
        });
    });
}

@end
