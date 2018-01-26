//
//  PJYellowPageTableViewCell.m
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJYellowPageTableViewCell.h"

@implementation PJYellowPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {

}

- (void)setCellDataSource:(ChineseString *)cellDataSource {
//    _nameLabel.text = [NSString stringWithFormat:@"%@", cellDataSource[@"name"]];
    _nameLabel.text = cellDataSource.string;
}

- (void)setDataDict:(NSDictionary *)dataDict{
    _nameLabel.text = [NSString stringWithFormat:@"%@", dataDict[@"name"]];
}

@end
