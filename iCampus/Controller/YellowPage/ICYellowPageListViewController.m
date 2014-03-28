//
//  ICYellowPageListViewController.m
//  iCampus
//
//  Created by Darren Liu on 13-12-25.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICYellowPageListViewController.h"
#import "../../View/YellowPage/ICYellowPageContactCell.h"
#import "../../Model/YellowPage/ICYellowPage.h"
#import "../ICControllerConfig.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ICYellowPageListViewController () <ABNewPersonViewControllerDelegate>

@property (nonatomic, strong) ICYellowPage     *yellowPage;
@property (nonatomic)         ABAddressBookRef  addressBook;

@end

@implementation ICYellowPageListViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.rowHeight = 48.0;
    self.title = self.department.name;
    ICYellowPageListViewController __weak *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __self.yellowPage = [[ICYellowPage yellowPageWithDepartment:self.department] yellowPageSortedByPinyin];
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.tableView reloadData];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return self.yellowPage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICYellowPageContact *contact = [self.yellowPage contactAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)contact.index]];
    if (!cell) {
        cell = [[ICYellowPageContactCell alloc] initWithContact:contact
                                                reuseIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)contact.index]];
    }
    return cell;
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICYellowPageContact *contact = [self.yellowPage contactAtIndex:indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.department.name
                                                        message:contact.name
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"拨号", @"加入通讯录", nil];
    [alertView show];
}

- (void)     alertView:(UIAlertView *)alertView
  clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1: {
            NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
            [self.tableView deselectRowAtIndexPath:indexPath
                                          animated:YES];
            ICYellowPageContact *contact = [self.yellowPage contactAtIndex:indexPath.row];
            NSString *urlString = [NSString stringWithFormat:@"tel://%@", contact.telephone];
            NSURL *url = [NSURL URLWithString:urlString];
#           if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_YELLOWPAGE_DIAL_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICYellowPageDialTag, ICFetchingTag, urlString);
#           endif
            if (![[UIApplication sharedApplication] openURL:url]) {
#               ifdef IC_YELLOWPAGE_DIAL_MODULE_DEBUG
                NSLog(@"%@ %@ %@", ICYellowPageDialTag, ICFailedTag, urlString);
#               endif
                break;
            }
#           if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_YELLOWPAGE_DIAL_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICYellowPageDialTag, ICSucceededTag, urlString);
#           endif
            break;
        }
        case 2: {
            self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
                    dispatch_semaphore_signal(semaphore);
                });
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法访问通讯录"
                                                                        message:@"请检查您的设置，确认本应用有权限访问您的通讯录。"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow
                                                  animated:YES];
                    break;
                }
            }
            [self performSegueWithIdentifier:(NSString *)ICYellowPageListToNewContactIdentifier
                                      sender:self];
            break;
        }
        default:
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow
                                          animated:YES];
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    ICYellowPageContact *contact = [self.yellowPage contactAtIndex:indexPath.row];
    ABRecordRef newPerson = ABPersonCreate();
    CFErrorRef error = NULL;
    ABMutableMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phones,
                                 (__bridge CFTypeRef)[ICSchoolTelephonePrefix stringByAppendingString:contact.telephone],
                                 kABPersonPhoneMainLabel,
                                 NULL);
    ABRecordSetValue(newPerson,
                     kABPersonPhoneProperty,
                     phones,
                     &error);
    CFRelease(phones);
    ABRecordSetValue(newPerson,
                     kABPersonOrganizationProperty,
                     (__bridge CFTypeRef)ICSchoolName,
                     &error);
    if (error) {
        CFRelease(error);
        return;
    }
    ABRecordSetValue(newPerson,
                     kABPersonFirstNameProperty,
                     (__bridge CFTypeRef)self.department.name,
                     &error);
    ABRecordSetValue(newPerson,
                     kABPersonLastNameProperty,
                     (__bridge CFTypeRef)contact.name,
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
