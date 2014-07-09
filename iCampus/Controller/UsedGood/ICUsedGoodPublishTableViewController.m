//
//  ICUsedGoodPublishTableViewController.m
//  iCampus
//
//  Created by EricLee on 14-6-3.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodPublishTableViewController.h"
#import "AFNetworking.h"
#import "ICUser.h"
#import "ICControllerConfig.h"
#import "ICUsedGoodPublishTableCellTableViewCell.h"
#import "ICUsedGoodImagePoster.h"
#import "ICUsedGoodType.h"
#import "ICLoginViewController.h"

@interface ICUsedGoodPublishTableViewController () <ICLoginViewControllerDelegate,UIActionSheetDelegate>




@property (strong,nonatomic) IBOutlet  ICUsedGoodImagePoster *imagePoster;
@property (strong, nonatomic) IBOutlet ICUsedGoodPublishTableCellTableViewCell *titleCell;
@property (strong, nonatomic) IBOutlet ICUsedGoodPublishTableCellTableViewCell *priceCell;
@property (strong, nonatomic) IBOutlet ICUsedGoodPublishTableCellTableViewCell *categoryCell;
@property (strong, nonatomic) IBOutlet ICUsedGoodPublishTableCellTableViewCell *phoneCell;
@property (strong, nonatomic) IBOutlet ICUsedGoodPublishTableCellTableViewCell *emailCell;
@property (strong, nonatomic) IBOutlet ICUsedGoodPublishTableCellTableViewCell *qqCell;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (nonatomic) ICUsedGoodType *selectedTypeID;
@property (nonatomic) NSMutableArray *typeList;
@property (nonatomic) NSString *typeID;
@property (nonatomic, strong) UIBarButtonItem* publish;
@property (nonatomic, strong) UIToolbar *toolbar;

@property BOOL firstAppear;

@end

@implementation ICUsedGoodPublishTableViewController



- (void)viewDidAppear:(BOOL)animated {
    if (!ICCurrentUser && self.firstAppear) {
        self.firstAppear = NO;
        [self performSegueWithIdentifier:(NSString *)ICUsedGoodPublishToLoginIdentifier sender:self];
    } else if (!ICCurrentUser && !self.firstAppear){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.firstAppear = YES;
    }
    return self;
}

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
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *title;
    NSString *done;
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        title =@"完成";
        done =@"完成";
    }
    else{
        title =@"Done";
        done = @"Done";
    }

    self.typeList=[NSMutableArray array];
    self.publish=[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(finishPublish:)];
    self.navigationItem.rightBarButtonItem=self.publish;
    
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIBarButtonItem *flexBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *dismissKeyBoardButton = [[UIBarButtonItem alloc] initWithTitle:done
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = @[flexBtn, dismissKeyBoardButton];
    [topView setItems:buttonsArray];
    [self.descriptionTextView setInputAccessoryView:topView];
    [self.titleCell.detailTextField setInputAccessoryView:topView];
    [self.priceCell.detailTextField setInputAccessoryView:topView];
    [self.phoneCell.detailTextField  setInputAccessoryView:topView];
    [self.emailCell.detailTextField  setInputAccessoryView:topView];
    [self.qqCell.detailTextField  setInputAccessoryView:topView];

    self.typeList=[NSMutableArray arrayWithArray:[ICUsedGoodType typeList]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)chooseCategory:(id)sender {
    NSMutableArray *namelist =[NSMutableArray array];
    for (ICUsedGoodType *type in self.typeList) {
        [namelist addObject:type.name];
    }
    UIActionSheet *sheet;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *title;
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            title =@"选择类型";
        }
        else{
            title =@"choose category";
        }

    sheet  = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *name in namelist) {
        [sheet addButtonWithTitle:name];
    }
    sheet.tag = 112;
    
    [sheet showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 112) {
        ICUsedGoodType *type=self.typeList[buttonIndex];
        self.typeID=type.ID;
        self.categoryCell.detailTextField.text=type.name;
        [self dismissKeyBoard];
    }
}

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICUsedGoodPublishTableCellTableViewCell *cell =(ICUsedGoodPublishTableCellTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    if (cell==self.categoryCell) {
        [self chooseCategory:self];
    }
}

- (void)dismissKeyBoard {
    [self.descriptionTextView resignFirstResponder];
    [self.titleCell.detailTextField  resignFirstResponder];
    [self.priceCell.detailTextField resignFirstResponder];
    [self.phoneCell.detailTextField  resignFirstResponder];
    [self.emailCell.detailTextField  resignFirstResponder];
    [self.qqCell.detailTextField resignFirstResponder];
    
}

-(IBAction)finishPublish:(id)sender{
    typedef BOOL (^CellTestingBlock)(ICUsedGoodPublishTableCellTableViewCell *);
    typedef void (^CellOperationBlock)(ICUsedGoodPublishTableCellTableViewCell *);
    CellTestingBlock hasValue = ^(ICUsedGoodPublishTableCellTableViewCell *cell) {
        return (BOOL)![cell.detailTextField.text isEqualToString:@""];
    };
    CellOperationBlock scrollTo = ^(ICUsedGoodPublishTableCellTableViewCell *cell) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    };
    self.titleCell.backgroundColor = self.priceCell.backgroundColor = [UIColor whiteColor];
    self.phoneCell.backgroundColor = self.emailCell.backgroundColor = self.qqCell.backgroundColor = [UIColor whiteColor];
//    self.titleCell.textLabel.backgroundColor = [UIColor clearColor];
    UIColor *errorColor = [UIColor colorWithRed:230.0/255.0 green:180.0/255.0 blue:200.0/255.0 alpha:0.5];
    if (!hasValue(self.titleCell)) {
        self.titleCell.backgroundColor = errorColor;
        scrollTo(self.titleCell);
        return;
    }
    
    if (!hasValue(self.priceCell)) {
        self.priceCell.backgroundColor = errorColor;
        scrollTo(self.priceCell);
        return;
    }
    if (!hasValue(self.categoryCell)) {
        self.categoryCell.backgroundColor = errorColor;
        scrollTo(self.categoryCell);
        [self dismissKeyBoard];
        return;
    }
    if (!hasValue(self.phoneCell) && !hasValue(self.emailCell) && !hasValue(self.qqCell)) {
        [self dismissKeyBoard];
        self.phoneCell.backgroundColor = self.emailCell.backgroundColor = self.qqCell.backgroundColor = errorColor;
        scrollTo(self.phoneCell);
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://m.bistu.edu.cn/newapi/secondhand_add.php"
       parameters:@{@"title": self.titleCell.detailTextField.text,
                    @"typeid": self.typeID,
                    @"xqdm": @"1",
                    @"description": self.descriptionTextView.text,
                    @"pic": self.imagePoster.imageURLString,
                    @"price": self.priceCell.detailTextField.text,
                    @"userid": ICCurrentUser.ID,
                    @"mobile":self.phoneCell.detailTextField.text,
                    @"email":self.emailCell.detailTextField.text,
                    @"QQ":self.qqCell.detailTextField.text,
                    } constructingBodyWithBlock:nil
          success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         
             [self.delegate publishViewController:self didPublish:YES];


         [self.navigationController popToRootViewControllerAnimated:YES];
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSArray *languages = [NSLocale preferredLanguages];
         NSString *currentLanguage = [languages objectAtIndex:0];
         NSString *title;
         NSString *message;
         NSString *cancel;
         if ([currentLanguage isEqualToString:@"zh-Hans"]) {
             title =@"错误";
             message =@"上传失败";
             cancel =@"确定";
             
         }
         else{
             title =@"Error";
             message =@"Upload Faild";
             cancel =@"Yes";
         }
         
         [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles: nil]show];
        }];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginViewController:(ICLoginViewController *)loginViewContrller
                       user:(ICUser *)user
                   didLogin:(BOOL)success {
    if (success) {
        [loginViewContrller dismissViewControllerAnimated:YES
                                               completion:nil];
    }
}

#pragma mark - Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:(NSString *)ICUsedGoodPublishToLoginIdentifier]) {
        ICLoginViewController *loginViewController = (ICLoginViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
        loginViewController.delegate = self;
    }
}

@end
