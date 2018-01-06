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
    self.busTypeLabel.textColor = RGB(150, 150, 150);
}

- (void)setCellDataSource:(NSDictionary *)cellDataSource {
    _cellDataSource = cellDataSource;
    _busNameLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"busName"]];
    _busTypeLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"busType"]];
    if ([cellDataSource[@"departureTime"] isEqualToString:@""]) {
        _departureTimeLabel.text = @"无";
    } else {
        _departureTimeLabel.text = [NSString stringWithFormat:@"%@ →", cellDataSource[@"departureTime"]];
    }
    if ([cellDataSource[@"returnTime"] isEqualToString:@""]) {
        _returnTimeLabel.text = @"无";
    } else {
        _returnTimeLabel.text = [NSString stringWithFormat:@"← %@", cellDataSource[@"returnTime"]];
    }
    if ([cellDataSource[@"busType"] isEqualToString:@"教学班车"]) {
        self.busTypeImage.image = [UIImage imageNamed:@"teachBus"];
    } else {
        self.busTypeImage.image = [UIImage imageNamed:@"normalBus"];
    }
}
@end
