//
//  KMPersonalMessageTabelViewController.m
//  iCampus
//
//  Created by xlx on 15/5/26.
//  Copyright (c) 2015年 BISTU. All rights reserved.
//

#import "KMPersonalMessageTabelViewController.h"

@interface KMPersonalMessageTabelViewController ()<PersonalMessageProtocol,UIAlertViewDelegate>
@property (nonatomic,strong) NSDictionary *PersonalMessage;
@property (nonatomic,strong) NSArray      *DetialTital;
@property (nonatomic,strong) NSArray      *key;
@property (nonatomic,strong) NSString     *number;
@end

@implementation KMPersonalMessageTabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_message receivedPersonnalDetial];
    _message.delegate                          = self;
    _DetialTital                               = @[@"学号：",@"QQ：",@"微信：",@"移动电话：",@"email："];
    _key                                       = @[@"userid",@"qq",@"wechat",@"mobile",@"email"];
    self.tableView.tableFooterView             = [[UIView alloc]init];
    self.navigationItem.title                  = _message.name;
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration           = 1.0;
    [self.tableView addGestureRecognizer:longPressGr];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
    CGPoint point                              = [gesture locationInView:self.tableView];
    NSIndexPath * indexPath                    = [self.tableView indexPathForRowAtPoint:point];
    UITableViewCell *cell                      = [self.tableView cellForRowAtIndexPath:indexPath];
        if(indexPath == nil) return ;
        [[UIPasteboard generalPasteboard] setPersistent:YES];
        [[UIPasteboard generalPasteboard] setValue:cell.detailTextLabel.text forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
        if ([cell.textLabel.text isEqualToString:@"移动电话："]) {
            [self CallPhone:cell.detailTextLabel.text];
        }else{
            [self copyanimation];
        }
    }
}
/**
 *  拨打电话
 *
 *
 */

-(void)CallPhone:(NSString *)number{
    NSString  *message     = [NSString stringWithFormat:@"是否拨打此电话“%@”",number ];
    _number                = [NSString stringWithFormat:@"tel://%@",number];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Call" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_number]];
    }
}
/**
 *  显示一个复制到粘贴板的提示
 */
-(void)copyanimation{
    UILabel *label                  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text                      = @"成功复制到粘贴板";
    label.backgroundColor           = [UIColor blackColor];
    label.textColor                 = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = true;
    [label.layer setCornerRadius:8];
    [label.layer setMasksToBounds:true];
    CGPoint cen                     = self.view.center;
    cen.y                           = self.view.bounds.size.height-70;
    label.center                    = cen;
    label.alpha                     = 0;
    [self.view addSubview:label];
    [UIView animateWithDuration:1 animations:^{
    label.alpha                     = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
    label.alpha                     = 0;
        }];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _DetialTital.count;
}
- (void)loadPersonalMessage{
    _PersonalMessage = _message.message[0];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.textLabel.text       = _DetialTital[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[_PersonalMessage valueForKey:_key[indexPath.row]]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
