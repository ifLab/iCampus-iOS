//
//  ICUsedGoodPublishTableCellTableViewCell.m
//  iCampus
//
//  Created by EricLee on 14-6-4.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodPublishTableCellTableViewCell.h"

@implementation ICUsedGoodPublishTableCellTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(112, 9, 188, 17)];
        self.detailTextField.text = self.detailTextLabel.text;
        self.detailTextField.font = self.detailTextLabel.font;
        self.detailTextField.backgroundColor = self.detailTextLabel.backgroundColor;
        self.detailTextField.textAlignment = self.detailTextLabel.textAlignment;
        self.detailTextField.textColor = self.detailTextLabel.textColor;
        self.detailTextField.placeholder = @"Essential";
        self.detailTextField.enabled = self.detailTextLabel.enabled;
        [self addSubview:self.detailTextField];
        self.detailTextLabel.hidden = YES;
    }
    return self;
}

@end
