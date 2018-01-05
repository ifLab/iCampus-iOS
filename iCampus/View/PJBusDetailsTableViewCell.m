//
//  PJBusDetailsTableViewCell.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJBusDetailsTableViewCell.h"

@implementation PJBusDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {
    self.backgroundColor = RGB(245, 245, 245);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setDataSource:(NSDictionary *)dataSource {
    _stationLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"station"]];
    _arrivalTimeLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"arrivalTime"]];
}

- (void)setType:(PJBusDetailsTableViewCellType)type {
    _type = type;
    switch (type) {
        case redType:
            [self redType]; break;
        case blueType:
            [self blueType]; break;
    }
}

- (void)redType {
    _arrivalTimeLabel.textColor = RGB(100, 149, 237);
    _arrivalTimeLabel.text = [NSString stringWithFormat:@"← %@", _arrivalTimeLabel.text];
}

- (void)blueType {
    _arrivalTimeLabel.textColor = RGB(238, 99, 99);
    _arrivalTimeLabel.text = [NSString stringWithFormat:@"→ %@", _arrivalTimeLabel.text];
}

@end
