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
    _backView.layer.cornerRadius = 15;
    _backView.layer.masksToBounds = YES;
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
    _backView.backgroundColor = RGB(255, 191, 174);
}

- (void)blueType {
    _backView.backgroundColor = RGB(152, 222, 255);
}

@end
