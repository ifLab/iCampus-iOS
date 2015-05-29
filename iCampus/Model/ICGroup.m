//
//  ICGroup.m
//  iCampus
//
//  Created by xlx on 15/5/26.
//  Copyright (c) 2015年 BISTU. All rights reserved.
//

#import "ICGroup.h"
#import "AFNetworking.h"
@implementation ICGroup
-(void)receivedPersonnalMessage:(NSString *)PersonalID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer             = [AFHTTPResponseSerializer serializer];
    NSString *urlPath                      = [NSString stringWithFormat:@"http://m.bistu.edu.cn/jiaowu/usergroup.php?userid=%@",PersonalID];
    NSDictionary *params                   = @{@"page" : @"2"};
    [manager GET:urlPath parameters:params success:

     ^(AFHTTPRequestOperation *operation, id responseObject) {

    NSData *data                           = operation.responseData;

    NSDictionary *dict                     = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _message                               = dict;
         [_delegate loadCompelect];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"下载错误 is %@",error);
             /**
              网络错误提醒
              */
    UIAlertView *alertview                 = [[UIAlertView alloc] initWithTitle:@"Warnning" message:@"发生网络问题，请稍后再试。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             [alertview show];
         }];
}
@end
