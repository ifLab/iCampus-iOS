//
//  mapView.m
//  prevail
//
//  Created by #incloud on 17/3/13.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "PJMapView.h"
#import <CoreLocation/CoreLocation.h>

@implementation PJMapView {
    MKMapView *_mapView;
    NSMutableArray *annotations;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _mapView = [[MKMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    [self addSubview:_mapView];
    
    [self initView];
    return self;
}

- (void)initView {
    _dataArr = [@[] mutableCopy];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = true;
    annotations = [@[] mutableCopy];
    
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self insertAnno];
}
-(void)insertAnno{
    [_mapView removeAnnotations:annotations];
    for (NSDictionary *dict in _dataArr) {
        MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
        annotation.title = dict[@"areaName"];
        annotation.subtitle = dict[@"areaAddress"];
        CGFloat latitude = [dict[@"latitude"] floatValue];
        CGFloat longitude = [dict[@"longitude"] floatValue];
        CLLocationCoordinate2D coordinate = {latitude,longitude};
        annotation.coordinate = coordinate;

        [_mapView addAnnotation:annotation];
        [annotations addObject:annotation];
    }
    
    CGFloat latitude = [_dataArr[1][@"latitude"] floatValue];
    CGFloat longitude = [_dataArr[1][@"longitude"] floatValue];
    CLLocationCoordinate2D coordinate = {latitude,longitude};
    [_mapView setCenterCoordinate:coordinate animated:YES];
    MKCoordinateSpan span = {0.1, 0.25};
    [_mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [_mapDelegate getSelectedAnnotation:view];
}

@end
