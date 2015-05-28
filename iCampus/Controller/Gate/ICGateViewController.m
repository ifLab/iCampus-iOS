//
//  ICViewController.m
//  iCampus
//
//  Created by Kwei Ma on 13-11-6.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICGateViewController.h"
#import "SVProgressHUD.h"

#define MSGBTN_NORMAL 1001
#define MSGBTN_HIGHLIGHTED 1002

@interface ICGateViewController () <ICLoginViewControllerDelegate, KMPageMenuViewControllerDataSource, KMPageMenuViewControllerDelegate>

@property (strong, nonatomic) NSArray *itemTitles;
@property (strong, nonatomic) NSArray *itemIcons;
@property (strong, nonatomic) NSArray *segues;
@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation ICGateViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"iBistu";
    self.messageButton.tag = MSGBTN_NORMAL;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.bistu.edu.cn/icampus_config.json"]];
    typeof(self) __weak self_ = self;
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            BOOL failed = true;
            if (!connectionError && data) {
                NSError *error;
                NSArray *configs = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (!error && configs.count > 0) {
                    failed = false;
                    NSDictionary *bistu = (NSDictionary *)configs[0]; // This will be changed in the universal version.
                    _ICCASAPIURLPrefix = bistu[@"CAS"];
                    _ICOAuthAPIURLPrefix = bistu[@"oAuth2"];
                    _ICEduAdminAPIURLPrefix = bistu[@"jwApi"];
                    _ICNewsAPIURLPrefix = bistu[@"newsApi"];
                    _ICDataAPIURLPrefix = bistu[@"icampusApi"];
                    if ([bistu[@"authType"] isEqual:@"oAuth2"]) {
                        _ICAuthType = ICAuthTypeOAuth;
                    } else if ([bistu[@"authType"] isEqual:@"CAS"]) {
                        _ICAuthType = ICAuthTypeCAS;
                    } else {
                        _ICAuthType = ICAuthTypeUnknown;
                    }
                }
            }
            if (failed) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"错误" message:@"无法获得服务器信息，可能是服务器维护中，应用即将被关闭。" preferredStyle:UIAlertControllerStyleActionSheet];
                [ac addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    exit(EXIT_SUCCESS);
                }]];
                [self_ presentViewController:ac animated:true completion:nil];
            }
        });
    }];
    
}

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkMessage:(id)sender
{
    if (self.messageButton.tag == MSGBTN_NORMAL) {
        self.messageButton.image = [UIImage imageNamed:@"ICNavigationBarMessageIcon"];
        self.messageButton.tag = MSGBTN_HIGHLIGHTED;
    } else {
        self.messageButton.image = [UIImage imageNamed:@"ICNavigationBarMessageHighlightedIcon"];
        self.messageButton.tag = MSGBTN_NORMAL;
    }
}

- (NSArray *)itemTitles
{
    if (!_itemTitles) {
        _itemTitles = @[@"新闻", @"学院", @"黄页", @"校车", @"地图", @"兼职", @"成绩", @"课程", @"教室", @"二手", @"群组", @"关于"];
    }
    return _itemTitles;
}

- (NSArray *)itemIcons
{
    if (!_itemIcons) {
        _itemIcons = @[[UIImage imageNamed:@"ICGateNewsIcon"],
                       [UIImage imageNamed:@"ICGateSchoolIcon"],
                       [UIImage imageNamed:@"ICGateYellowPageIcon"],
                       [UIImage imageNamed:@"ICGateBusIcon"],
                       [UIImage imageNamed:@"ICGateMapIcon"],
                       [UIImage imageNamed:@"JobSeekerIcon"],
                       [UIImage imageNamed:@"FrontIconsGradeSearch"],
                       [UIImage imageNamed:@"FrontIconsClassTable"],
                       [UIImage imageNamed:@"FrontIconsFreeRooms"],
                       [UIImage imageNamed:@"ICGatePlaceHolder"],
                       [UIImage imageNamed:@"ICGatePlaceHolder"],
                       [UIImage imageNamed:@"ICGatePlaceHolder"]
                       ];
    }
    return _itemIcons;
}

- (NSArray *)segues
{
    if (!_segues) {
        _segues = @[@"IC_GATE_TO_NEWS",
                    @"IC_GATE_TO_SCHOOL",
                    @"IC_GATE_TO_YELLOWPAGE",
                    @"IC_GATE_TO_BUS",
                    @"IC_GATE_TO_MAP",
                    @"IC_GATE_TO_JOB",
                    @"IC_GATE_TO_GRADE",
                    @"IC_GATE_TO_CLASSTABLE",
                    @"IC_GATE_TO_FREEROOM",
                    @"IC_GATE_TO_USEDGOOD",
                    @"IC_GATE_TO_GROUP",
                    @"IC_GATE_TO_ABOUT"];
    }
    return _segues;
}

#pragma mark - KMPageMenuViewController Data Source

- (int)numberOfPagesInPageMenuViewController:(KMPageMenuViewController *)pageMenuViewController
{
    return 1;
}

- (int)pageMenuViewController:(KMPageMenuViewController *)pageMenuViewController numberOfItemsInPage:(NSInteger)pageIndex
{
    return (int)self.itemTitles.count;
}

- (KMPageMenuItem *)pageMenuViewController:(KMPageMenuViewController *)pageMenuViewController itemAtPage:(int)page position:(int)position
{
    return [[KMPageMenuItem alloc] initWithIcon:self.itemIcons[position] title:self.itemTitles[position]];
}

#pragma mark - KMPageMenuViewControllerDelegate

- (void)pageMenuViewController:(KMPageMenuViewController *)pageMenuViewController didSelectItemAtPage:(int)page position:(int)position
{
    [self performSegueWithIdentifier:self.segues[position] sender:self];
}

#pragma mark - Login Actions

- (IBAction)toggleLoginPage:(UIBarButtonItem *)sender
{
    ICLoginViewController *loginViewController = [[ICLoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

#pragma mark - ICLoginViewControllerDelegate

- (void)loginViewController:(ICLoginViewController *)loginViewContrller
                       user:(ICUser *)user
                   didLogin:(BOOL)success {}

@end
