//
//  ICBusStationView.h
//  iCampus
//
//  Created by Darren Liu on 13-12-21.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICBusStation;

@interface ICBusStationView : UIView

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;

- (id)initWithStation:(ICBusStation *)station
              isFirst:(BOOL)first
               isLast:(BOOL)last;

@end
