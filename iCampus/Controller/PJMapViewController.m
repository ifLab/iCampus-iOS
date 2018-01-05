//
//  PJMapViewController.m
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJMapViewController.h"
#import "PJMapView.h"
#import "PJBusViewController.h"
#import "ICNetworkManager.h"

@interface PJMapViewController () <PJMapViewDelegate>

@property (nonatomic, strong) MKAnnotationView *kAnnotationView;
@property (nonatomic, assign) BOOL isSelectAnnotation;
// 上次选中的索引(或者控制器)
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation PJMapViewController {
    PJMapView *_kMapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [PJHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSeleted) name:@"tabBarDidSelectedNotification" object:nil];
    
    self.title = @"地图";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isSelectAnnotation = false;
    _kMapView = [[PJMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _kMapView.mapDelegate = self;
    [self.view addSubview:_kMapView];
    
    //左侧校车入口
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"busTime"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"mapNav"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];

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
                                       NSLog(@"获取Map信息失败,%@",error);
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
                   launchOptions:@{
                                   MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]
                                   }];
    return;
}

- (void)leftItemClick {
    PJBusViewController *bus = [[PJBusViewController alloc] init];
    //隐藏本层的TabBar
    bus.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bus animated:YES];
        
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSDictionary *dict = @{@"userEmail":[PJUser currentUser].email,@"time":dateString};
    
    [MobClick event:@"ibistu_bus_click" attributes:dict];
}

- (void)rightItemClick {
    if (self.isSelectAnnotation) {
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:date];
        NSDictionary *dic = @{
                              @"username" : [PJUser currentUser].first_name,
                              @"uploadtime" : dateString,
                              @"goto" : self.kAnnotationView.annotation.title
                              };
        [MobClick event:@"ibistu_map_nav" attributes:dic];
        
        [NSString stringWithFormat:@"%@", self.kAnnotationView];
        [self gothereWithAddress:[NSString stringWithFormat:@"北京信息科技大学%@", self.kAnnotationView.annotation.title]
                          andLat:[NSString stringWithFormat:@"%f", self.kAnnotationView.annotation.coordinate.latitude]
                          andLon:[NSString stringWithFormat:@"%f", self.kAnnotationView.annotation.coordinate.longitude]];
    }else {
        [PJHUD showErrorWithStatus:@"请先选择地点"];
    }
}

- (void)getSelectedAnnotation:(MKAnnotationView *)view {
    self.kAnnotationView = view;
    self.isSelectAnnotation = true;
}

// 点击两次tab刷新当前VC
- (void)tabBarSeleted {
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex) {
        [self getDataFromHttp];
    }
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}

@end
