//
//  ICBusStationCell.m
//  iCampus
//
//  Created by Darren Liu on 13-12-20.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICBusStationListCell.h"
#import "../../Model/Bus/ICBus.h"
#import "ICBusStationView.h"

@implementation ICBusStationListCell

- (id)initWithStationList:(ICBusStationList *)stationList
          reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:reuseIdentifier];
    if (self) {
        self.stationList = stationList;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusExpandingBackground"]];
        _scrollView  = [[UIScrollView alloc] init]; {
            self.scrollView.frame           = CGRectMake(0, 0, 320.0, 120.0);
            self.scrollView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:245/255.0 alpha:0.5];
            [self.contentView addSubview:self.scrollView];
        }
        UIView *line = [[UIView       alloc] init]; {
            line.frame           = CGRectMake(0, 119.0, 320.0, 1.0);
            line.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
            [self.contentView addSubview:line];
        }
        self.stationList = nil;
    }
    return self;
}

- (void)setStationList:(ICBusStationList *)stationList {
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    _stationList = stationList;
    for (int i = 0; i < self.stationList.count; i++) {
        BOOL first = (i == 0);
        BOOL last = (i == self.stationList.count - 1);
        UIView *view = [[UIView alloc] init]; {
            view.frame = CGRectMake(110.0 * i, 0.0, 110.0, 120.0);
            ICBusStationView *stationView = [[ICBusStationView alloc] initWithStation:[self.stationList stationAtIndex:i]
                                                                              isFirst:first
                                                                               isLast:last];
            [view addSubview:stationView];
        }
        [self.scrollView addSubview:view];
    }
    self.scrollView.contentSize = CGSizeMake(110.0 * self.stationList.count, 100);
}

@end
