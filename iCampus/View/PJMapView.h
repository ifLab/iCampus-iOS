//
//  mapView.h
//  prevail
//
//  Created by #incloud on 17/3/13.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol PJMapViewDelegate <NSObject, MKMapViewDelegate>

- (void)getSelectedAnnotation:(MKAnnotationView *)view;

@end

@interface PJMapView : UIView <MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
-(void)insertAnno;

@property (nonatomic, weak) id<PJMapViewDelegate> mapDelegate;
@end
