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
#import "ICControllerConfig.h"

@interface ICUsedGoodDetailViewController ()<UIActionSheetDelegate,ABNewPersonViewControllerDelegate>
@property (nonatomic, strong) ICUsedGoodDetail *usedGoodDetail;
@property (nonatomic, strong) ICUsedGoodDetailView *detailView;
@property (nonatomic)         ABAddressBookRef  addressBook;
@end

@implementation ICUsedGoodDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *languages = [NSLocale preferredLanguages];
     NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        self.title=@"二手物品";
    }else{
    self.title=@"Detail";
    }
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
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *title;
    NSString *cancel;
    NSString *Phone;
    NSString *email;
    NSString *contact;

    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        title=@"联系方式";
        cancel=@"取消";
        Phone=@"手机";
        email=@"邮箱";
        contact=@"添加到联系人";
    }else{
        title=@"Contact";
        cancel=@"Cancel";
        Phone=@"Phone";
        email=@"Email";
        contact=@"添加到联系人";
    }
    sheet  = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancel destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"%@:%@",Phone, self.usedGood.Phone],[NSString stringWithFormat:@"%@:%@", email,self.usedGood.Email],[NSString stringWithFormat:@"QQ:%@", self.usedGood.QQ],contact,nil];

      sheet.tag = 113;
    
    [sheet showInView:self.view];
}

-(IBAction)deleteUsedGood :(id)sender{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url=[NSString stringWithFormat:@"%@/secondhand_unvalid.php?id=%@", ICUsedGoodAPIURLPrefix, self.usedGood.ID];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //NSLog(@"success");
             [self.navigationController popViewControllerAnimated:YES];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSString *title;
             NSString *message;
             NSString *cancel;
             if ([currentLanguage isEqualToString:@"zh-Hans"]) {
                 title =@"错误";
                 message =@"删除失败";
                 cancel =@"确定";
             }
             else{
                 title =@"Error";
                 message =@"Delete Faild";
                 cancel =@"Yes";
             }
             [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Delete Faild" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: nil]show];
         }];
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *title;
    NSString *message;
    NSString *cancel;
    if (actionSheet.tag == 113) {
        switch (buttonIndex) {
            case 0:
            {
                NSString *urlString = [NSString stringWithFormat:@"tel://%@", self.usedGood.Phone];
                NSURL *url = [NSURL URLWithString:urlString];
                if (![[UIApplication sharedApplication] openURL:url]) {
                    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
                        title =@"错误";
                        message =@"你不能打给这个人";
                        cancel =@"确定";

                    }
                    else{
                        title =@"Error";
                        message =@"You can not call this person";
                        cancel =@"Yes";
                    }

                    [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil]show];
                }
                break;
            }
            case 1:{
//                NSLog(@"1");
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.usedGood.Email;
                if ([currentLanguage isEqualToString:@"zh-Hans"]) {
                    title =@"提示";
                    message =@"邮箱地址已复制到剪切板";
                    cancel =@"确定";
                    
                }
                else{
                    title =@"Tip";
                    message =@"Email address has been copied to Pasteboard.";
                    cancel =@"Yes";
                    
                }
                [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil]show];
                break;
            }
            case 2:{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.usedGood.QQ;
                if ([currentLanguage isEqualToString:@"zh-Hans"]) {
                    title =@"提示";
                    message =@"QQ地址已复制到剪切版";
                    cancel =@"确定";
                }
                else{
                    title =@"Tip";
                    message =@"QQ number has been copied to Pasteboard.";
                    cancel =@"Yes";
                    
                }
               [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil]show];                break;
            }
            case 3:{
                self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
                    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!granted) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法访问通讯录"
                                                                                    message:@"请检查您的设置，确认本应用有权限访问您的通讯录。"
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"好" otherButtonTitles:nil];
                                [alertView show];
                            } else {
                                [self performSegueWithIdentifier:(NSString *)ICUsedGoodDetailToContactIdentifier
                                                          sender:self];
                            }
                        });
                    });
                } else {
                    [self performSegueWithIdentifier:(NSString *)ICUsedGoodDetailToContactIdentifier
                                              sender:self];
                }
                break;

            }
                
            default:

                break;
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    ABRecordRef newPerson = ABPersonCreate();
    CFErrorRef error = NULL;
    ABMutableMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phones,
                                 (__bridge CFTypeRef)[ICSchoolTelephonePrefix stringByAppendingString:self.usedGood.Phone],
                                 kABPersonPhoneMainLabel,
                                 NULL);
//    ABMutableMultiValueRef qq = ABMultiValueCreateMutable(kABMultiDateTimePropertyType);
//    ABMultiValueAddValueAndLabel(qq,
//                                 (__bridge CFTypeRef)self.usedGood.QQ,
//                                 kABPersonInstantMessageServiceQQ,
//                                 NULL);
//    ABRecordSetValue(newPerson,
//                     kABPersonPhoneProperty,
//                     email,
//                     &error);
    ABRecordSetValue(newPerson,
                     kABPersonPhoneProperty,
                     phones,
                     &error);
    CFRelease(phones);
//    CFRelease(qq);
    
    ABRecordSetValue(newPerson,
                     kABPersonOrganizationProperty,
                     (__bridge CFTypeRef)ICSchoolName,
                     &error);
    if (error) {
        CFRelease(error);
        return;
    }
    ABNewPersonViewController *newPersonViewController = [[ABNewPersonViewController alloc] init];
    newPersonViewController.displayedPerson = newPerson;
    newPersonViewController.newPersonViewDelegate = self;
    UINavigationController *navigationController = ((UINavigationController *)segue.destinationViewController);
    [navigationController pushViewController:newPersonViewController
                                    animated:NO];
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView
       didCompleteWithNewPerson:(ABRecordRef)person {
    [newPersonView dismissViewControllerAnimated:YES
                                      completion:nil];
    CFErrorRef error = NULL;
    ABAddressBookAddRecord(self.addressBook, person, &error);
    if (error) {
        CFRelease(error);
        return;
    }
    ABAddressBookSave(self.addressBook, &error);
    if (error) {
        CFRelease(error);
        return;
    }
    CFRelease(self.addressBook);
    self.addressBook = NULL;
}




@end