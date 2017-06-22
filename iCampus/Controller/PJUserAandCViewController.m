//
//  PJUserAandCViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/3.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJUserAandCViewController.h"
#import "ICNetworkManager.h"
#import "PJUserUpdatePWViewController.h"

@interface PJUserAandCViewController ()

@end

@implementation PJUserAandCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = @"账号与安全";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 重置密码
    if (indexPath.row == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要重置密码么？" message:@"重置成功后将会给您发送一封邮件" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self sureClick];
            self.tableView.editing = NO;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            self.tableView.editing = NO;
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
    if (indexPath.row == 0) {
        [self updatePW];
    }
}

// 此功能未完成
- (void)sureClick {
    NSDictionary *paramters = @{@"email":[PJUser currentUser].email};
    [[ICNetworkManager defaultManager] POST:@"Reset"
                             GETParameters:nil
                             POSTParameters:paramters
                                   success:^(NSDictionary *dict) {
                                       
                                       if (dict[@"success"]) {
                                           [PJHUD showSuccessWithStatus:@"请查看邮箱"];
                                       }
                                    } failure:^(NSError *erroe) {
                                        NSLog(@"%@", erroe);
                                    }];
}

- (void)updatePW {
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"PJUserUpdatePW" bundle:nil];
    PJUserUpdatePWViewController *vc = [SB instantiateViewControllerWithIdentifier:@"PJUserUpdatePWViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
