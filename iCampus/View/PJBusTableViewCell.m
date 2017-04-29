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
    _departureTimeLabel.textColor = RGB(30, 144, 255);
    _returnTimeLabel.font = [UIFont systemFontOfSize:12];
    _returnTimeLabel.textColor = RGB(255, 99, 71);
}

- (void)setCellDataSource:(NSDictionary *)cellDataSource {
    _cellDataSource = cellDataSource;
    _busNameLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"busName"]];
    _busTypeLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"busType"]];
    if ([cellDataSource[@"departureTime"] isEqualToString:@""]) {
        _departureTimeLabel.text = @"出发：无";
    } else {
        _departureTimeLabel.text = [NSString stringWithFormat:@"出发：%@", cellDataSource[@"departureTime"]];
    }
    if ([cellDataSource[@"returnTime"] isEqualToString:@""]) {
        _returnTimeLabel.text = @"回程：无";
    } else {
        _returnTimeLabel.text = [NSString stringWithFormat:@"回程：%@", cellDataSource[@"returnTime"]];
    }
}
@end
