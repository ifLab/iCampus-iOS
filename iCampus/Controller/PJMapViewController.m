//
//  PJMapViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJMapViewController.h"
#import "PJMapView.h"
#import "ICNetworkManager.h"

@interface PJMapViewController () <PJMapViewDelegate>
@property (nonatomic, strong) MKAnnotationView *kAnnotationView;
@end

@implementation PJMapViewController
{
    PJMapView *_kMapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.title = @"校区地图";
    self.view.backgroundColor = [UIColor whiteColor];
    _kMapView = [[PJMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _kMapView.mapDelegate = self;
    [self.view addSubview:_kMapView];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"导航_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = false;

    [self getDataFromHttp];
}

- (void)getDataFromHttp {
    [[ICNetworkManager defaultManager] GET:@"Map"
                                parameters:nil
                                   success:^(NSDictionary *dic) {
                                       NSArray *data = dic[@"resource"];;
                                       _kMapView.dataArr = [data mutableCopy];
                                   }
                                   failure:^(NSError *error) {
                                       // error信息要怎么处理？
                                   }];
}

-(BOOL)canOpenUrl:(NSString *)string {
    return  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:string]];
}

- (void)gothereWithAddress:(NSString *)address andLat:(NSString *)lat andLon:(NSString *)lon {
    //跳转系统地图
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    toLocation.name = address;
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    return;
}

- (void)rightItemClick {
    [NSString stringWithFormat:@"%@", self.kAnnotationView];
    [self gothereWithAddress:[NSString stringWithFormat:@"北京信息科技大学%@", self.kAnnotationView.annotation.title] andLat:[NSString stringWithFormat:@"%f", self.kAnnotationView.annotation.coordinate.latitude] andLon:[NSString stringWithFormat:@"%f", self.kAnnotationView.annotation.coordinate.longitude]];
}

- (void)getSelectedAnnotation:(MKAnnotationView *)view {
    self.kAnnotationView = view;
    self.navigationItem.rightBarButtonItem.enabled = true;
    [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"导航"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

@end
