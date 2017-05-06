//
//  PJUserUpdatePWViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/3.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJUserUpdatePWViewController.h"
#import "logoutFoot.h"
#import "ICNetworkManager.h"

@interface PJUserUpdatePWViewController () <UITextFieldDelegate>

@end

@implementation PJUserUpdatePWViewController
{
    logoutFoot *_footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    _nameTextField.text = [NSString stringWithFormat:@"%@", [PJUser currentUser].email];
    [_oldPWTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_newnewPWTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_againNewPWTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_oldPWTextField endEditing:YES];
    [_newnewPWTextField endEditing:YES];
    [_againNewPWTextField endEditing:YES];
}

- (void)rightItemClick {
    [self updatePw];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([_oldPWTextField.text length] > 0 && [_newnewPWTextField.text length] > 0 && [_againNewPWTextField.text length] > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (BOOL)submit {
    if ([_oldPWTextField.text isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"输入原密码"];
        return NO;
    }
    if ([_newnewPWTextField.text isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"输入新密码"];
        return NO;
    }
    if ([_againNewPWTextField.text isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"再次输入新密码"];
        return NO;
    }
    return YES;
}

- (void)updatePw{
    if ([self submit]) {
        NSDictionary *paramters = @{@"old_password":_oldPWTextField.text,
                                    @"new_password":_newnewPWTextField.text,
                                    @"email":[PJUser currentUser].email};
        [self updatePWwithHttp:paramters];
    }
}

- (void)updatePWwithHttp:(NSDictionary *)paramters {
    
    [[ICNetworkManager defaultManager] POST:@"Update PW"
                              GETParameters:nil
                             POSTParameters:paramters
                                    success:^(NSDictionary *dict) {
                                        
                                    } failure:^(NSError *error) {
                                        NSLog(@"%@", error);
                                    }];
}

@end
