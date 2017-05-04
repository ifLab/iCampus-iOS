//
//  PJBusTableViewCell.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJBusTableViewCell.h"

@implementation PJBusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView{
    _busNameLabel.font = [UIFont systemFontOfSize:15];
    _busTypeLabel.font = [UIFont systemFontOfSize:12];
    _departureTimeLabel.font = [UIFont systemFontOfSize:12];
    _returnTimeLabel.font = [UIFont systemFontOfSize:12];
    
//    CGRect frame = _busNameLabel.frame;
//    _busNameLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH * 0.4, frame.size.height);
}

- (void)setCellDataSource:(NSDictionary *)cellDataSource {
    _cellDataSource = cellDataSource;
    _busNameLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"busName"]];
    _busTypeLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"busType"]];
    if ([cellDataSource[@"departureTime"] isEqualToString:@""]) {
        _departureTimeLabel.text = @"无";
    } else {
        _departureTimeLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"departureTime"]];
    }
    if ([cellDataSource[@"returnTime"] isEqualToString:@""]) {
        _returnTimeLabel.text = @"无";
    } else {
        _returnTimeLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"returnTime"]];
    }
    if ([cellDataSource[@"busType"] isEqualToString:@"教学班车"]) {
//        _busTypeImg.image = [UIImage imageNamed:@"Bus_2"];
        self.imageView.image = [UIImage imageNamed:@"Bus_2"];
    } else {
//        _busTypeImg.image = [UIImage imageNamed:@"ICBusIcon"];
        self.imageView.image = [UIImage imageNamed:@"ICBusIcon"];
    }
}
@end
