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

@interface PJUserUpdatePWViewController ()

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
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"settingXIB" owner:self options:nil];
    _footer = views.firstObject;
    self.tableView.tableFooterView = _footer;
    [_footer.logoutBtn setTitle:@"提交修改" forState:UIControlStateNormal];
    [_footer.logoutBtn setBackgroundColor:mainGreen];
    _footer.logoutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_footer.logoutBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_oldPWTextField endEditing:YES];
    [_newnewPWTextField endEditing:YES];
    [_againNewPWTextField endEditing:YES];
}

- (void)submit {
    if ([_oldPWTextField.text isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"输入原密码"];
        return;
    }
    if ([_newnewPWTextField.text isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"输入新密码"];
        return;
    }
    if ([_againNewPWTextField.text isEqualToString:@""]) {
        [PJHUD showErrorWithStatus:@"再次输入新密码"];
        return;
    }
    NSDictionary *dict = @{@"old_password":_oldPWTextField.text,
                           @"new_password":_newnewPWTextField.text,
                           @"email":[PJUser currentUser].email
                           };
    [self updatePW:dict];
}

- (void)updatePW:(NSDictionary *)paramters {
    
    [[ICNetworkManager defaultManager] POST:@"Update PW"
                              GETParameters:nil
                             POSTParameters:paramters
                                    success:^(NSDictionary *dict) {
                                        if (dict[@"success"]) {
            
                                        }
                                    } failure:^(NSError *error) {
        
                                    }];
}

@end
