//
//  ICUsedGoodDetailViewController.m
//  iCampus
//
//  Created by EricLee on 14-4-8.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodDetailViewController.h"
#import "ICUsedGoodDetailView.h"
#import "AFNetworking.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface ICUsedGoodDetailViewController ()<UIActionSheetDelegate>
@property (nonatomic, strong) ICUsedGoodDetail *usedGoodDetail;
@property (nonatomic, strong) ICUsedGoodDetailView *detailView;

@end

@implementation ICUsedGoodDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Detail";
    [self.del addTarget:self action:@selector(deleteUsedGood:) forControlEvents:UIControlEventTouchUpInside];
    self.detailView=[[ICUsedGoodDetailView alloc] initWithUsedGood:self.usedGood
                                                             frame:self.view.frame];
    [self.detailView.detailButton addTarget:self action:@selector(showContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.detailView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)showContact:(id)sender {
    UIActionSheet *sheet;
    sheet  = [[UIActionSheet alloc] initWithTitle:@"Contact" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"Phone:%@", self.usedGood.Phone],[NSString stringWithFormat:@"Email:%@", self.usedGood.Email],[NSString stringWithFormat:@"QQ:%@", self.usedGood.QQ],nil];
    sheet.tag = 113;
    
    [sheet showInView:self.view];
}

-(IBAction)deleteUsedGood :(id)sender{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url=[NSString stringWithFormat:@"http://m.bistu.edu.cn/newapi/secondhand_unvalid.php?id=%@",self.usedGood.ID];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //NSLog(@"success");
             [self.navigationController popViewControllerAnimated:YES];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Delete Faild" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: nil]show];
             //NSLog(@"fail");
         }];
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 113) {
        switch (buttonIndex) {
            case 0:
            {
                NSString *urlString = [NSString stringWithFormat:@"tel://%@", self.usedGood.Phone];
                NSURL *url = [NSURL URLWithString:urlString];
                if (![[UIApplication sharedApplication] openURL:url]) {
                    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"You can not call this person" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: nil]show];
                    NSLog(@"fales");
                }
                break;
            }
            case 1:{
//                NSLog(@"1");
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.usedGood.Email;
                [[[UIAlertView alloc]initWithTitle:@"Tip" message:@"Email address has been copied to Pasteboard." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: nil]show];
                break;
            }
            case 2:{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.usedGood.QQ;
                [[[UIAlertView alloc]initWithTitle:@"Tip" message:@"QQ number has been copied to Pasteboard." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: nil]show];
//                NSLog(@"2");
                break;
            }
            default:
//                NSLog(@"3");
                break;
        }
    }
}


@end