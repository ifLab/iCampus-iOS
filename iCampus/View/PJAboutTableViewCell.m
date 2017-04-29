//
//  PJAboutTableViewCell.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJAboutTableViewCell.h"

@implementation PJAboutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {
    _aboutNameLabel.font = [UIFont systemFontOfSize:28];
}

- (void)setDataSource:(NSDictionary *)dataSource {
    _dataSource = dataSource;
    _aboutNameLabel.text = dataSource[@"aboutName"];
}

@end
