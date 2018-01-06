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
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.2;
}

- (void)setDataSource:(NSDictionary *)dataSource {
    _dataSource = dataSource;
    NSString *focusString = dataSource[@"aboutName"];
    if ([focusString isEqualToString:@"Credits"]) {
        _aboutNameLabel.text = focusString;
        _aboutNameLabel.textColor = [UIColor whiteColor];
    } else if ([focusString isEqualToString:@"ifLab"]) {
        _aboutNameLabel.text = @"";
        _bgView.hidden = true;
    } else {
        _aboutNameLabel.text = dataSource[@"aboutName"];
    }
}

@end
