//
//  ICMapViewController.m
//  iCampus
//
//  Created by Kwei Ma on 14-3-10.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICMapViewController.h"
#import "ICMap.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

const CGFloat MenuViewHeight = 160.0f;
const CGFloat InfoViewHeight = 60.0f;

@interface ICMapViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ICMap *mapModel;
@property (strong, nonatomic) NSArray *list;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)dismiss:(id)sender;
- (IBAction)showMenu:(id)sender;

@property (strong, nonatomic) UITableView *menuView;
@property BOOL isMenuViewShowing;

@property (strong ,nonatomic) UIView *infoView;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *zipCodeLabel;

@end

@implementation ICMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapModel = [[ICMap alloc] init];
    
    
    // Menu view
    self.menuView = [[UITableView alloc] initWithFrame:CGRectMake(0, -MenuViewHeight, 320.0, MenuViewHeight) style:UITableViewStylePlain];
    self.menuView.dataSource = self;
    self.menuView.delegate = self;
    self.menuView.rowHeight = 50.0;
    self.menuView.clipsToBounds = YES;
    self.menuView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.menuView];
    self.menuView.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    self.menuView.layer.shadowOffset = CGSizeMake(0, 50);
    self.menuView.layer.shadowOpacity = 0;
    
    self.isMenuViewShowing = NO;
    
    
    // Information view
    CGRect infoViewFrame = CGRectMake(0, self.view.frame.size.height-InfoViewHeight-64.0, 320.0, InfoViewHeight);
    self.infoView = [[UIView alloc] initWithFrame:infoViewFrame];
    self.infoView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    self.infoView.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    self.infoView.layer.shadowOffset = CGSizeMake(0, -2);
    self.infoView.layer.shadowOpacity = 0.2;
    [self.view addSubview:self.infoView];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 320.0, 20.0)];
    self.addressLabel.font = [UIFont systemFontOfSize:16.0];
    self.addressLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.infoView addSubview:self.addressLabel];
    
    self.zipCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 30.0, 320.0, 20.0)];
    self.zipCodeLabel.font = [UIFont systemFontOfSize:14.0];
    self.zipCodeLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.infoView addSubview:self.zipCodeLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [self loadData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showMenu:(id)sender
{
    CGRect frame;
    if (self.isMenuViewShowing) {
        frame = CGRectMake(0, 0, 320.0, MenuViewHeight);
        self.menuView.layer.shadowOpacity = 0.2;
    } else {
        frame = CGRectMake(0, -MenuViewHeight, 320.0, MenuViewHeight);
        self.menuView.layer.shadowOpacity = 0;
    }
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.menuView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.isMenuViewShowing = !self.isMenuViewShowing;
                     }];
}

- (void)loadData
{
    self.list = [self.mapModel mapList];
    
    [self.menuView reloadData];
    
    self.addressLabel.text = (NSString *)[self.list[0] objectForKey:ICMapAddress];
    self.zipCodeLabel.text = (NSString *)[self.list[0] objectForKey:ICMapZipCode];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = ((NSNumber *)[self.list[0] objectForKey:ICMapLongitude]).floatValue;
    zoomLocation.longitude= ((NSNumber *)[self.list[0] objectForKey:ICMapLatitude]).floatValue;
    
    CGFloat zoomLevel = ((NSNumber *)[self.list[0] objectForKey:ICMapZoomLevel]).floatValue * 60;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoomLevel, zoomLevel);
    
    [self.mapView setRegion:viewRegion animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [self.list[indexPath.row] objectForKey:ICMapName];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.addressLabel.text = (NSString *)[self.list[indexPath.row] objectForKey:ICMapAddress];
    self.zipCodeLabel.text = (NSString *)[self.list[indexPath.row] objectForKey:ICMapZipCode];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = ((NSNumber *)[self.list[indexPath.row] objectForKey:ICMapLongitude]).floatValue;
    zoomLocation.longitude= ((NSNumber *)[self.list[indexPath.row] objectForKey:ICMapLatitude]).floatValue;
    
    CGFloat zoomLevel = ((NSNumber *)[self.list[indexPath.row] objectForKey:ICMapZoomLevel]).floatValue * 60;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoomLevel, zoomLevel);
    
    [self.mapView setRegion:viewRegion animated:YES];
    
    CGRect frame;
    if (self.isMenuViewShowing) {
        frame = CGRectMake(0, 0, 320.0, MenuViewHeight);
        self.menuView.layer.shadowOpacity = 0.2;
    } else {
        frame = CGRectMake(0, -MenuViewHeight, 320.0, MenuViewHeight);
        self.menuView.layer.shadowOpacity = 0;
    }
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.menuView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.isMenuViewShowing = !self.isMenuViewShowing;
                     }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
