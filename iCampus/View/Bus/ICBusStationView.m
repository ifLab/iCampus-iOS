//
//  ICBusStationView.m
//  iCampus
//
//  Created by Darren Liu on 13-12-21.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICBusStationView.h"
#import "ICBusStation.h"

@implementation ICBusStationView

- (id)initWithStation:(ICBusStation *)station
              isFirst:(BOOL)first
               isLast:(BOOL)last {
    self = [self init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; {
            dateFormatter.dateFormat = @"HH:mm";
            dateFormatter.timeZone = [NSTimeZone localTimeZone];
        }
        self.nameLabel.text = station.name;
        self.timeLabel.text = station.time? [dateFormatter stringFromDate:station.time] : @"-";
        if (first) {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusStationFirst"]];
        } else if (last) {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusStationLast"]];
        } else {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusStationNormal"]];
        }
    }
    return self;
}

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 120.0, 100.0)];
    if (self) {
        for (UIView *view in self.subviews) {
            [self removeFromSuperview];
        }
        _nameLabel = [[UILabel alloc] init]; {
            self.nameLabel.frame         = CGRectMake(0.0, 10.0, 120.0, 40.0);
            self.nameLabel.textAlignment = NSTextAlignmentCenter;
            self.nameLabel.font          = [UIFont systemFontOfSize:14.0];
            self.nameLabel.textColor     = [UIColor darkTextColor];
            self.nameLabel.numberOfLines = 2;
            [self addSubview:self.nameLabel];
        }
        _timeLabel = [[UILabel alloc] init]; {
            self.timeLabel.frame         = CGRectMake(0.0, 45.0, 120.0, 20.0);
            self.timeLabel.textAlignment = NSTextAlignmentCenter;
            self.timeLabel.font          = [UIFont systemFontOfSize:12.0];
            self.timeLabel.textColor     = [UIColor grayColor];
            [self addSubview:self.timeLabel];
        }
    }
    return self;
}

@end
