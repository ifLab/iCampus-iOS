//
//  ICYellowPageContactCell.m
//  iCampus
//
//  Created by Darren Liu on 13-12-25.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICYellowPageContactCell.h"
#import "../../Model/YellowPage/ICYellowPage.h"

@implementation ICYellowPageContactCell

- (id)initWithContact:(ICYellowPageContact *)contact
      reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel.text  = contact.name;
        self.phoneLabel.text = contact.telephone;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel  = self.textLabel; {
            self.nameLabel.font = [UIFont systemFontOfSize:15.0f];
            self.nameLabel.textColor = [UIColor darkTextColor];
        }
        _phoneLabel = [[UILabel alloc] init]; {
            self.phoneLabel.frame           = CGRectMake(0, 0, 80, self.frame.size.height);
            self.phoneLabel.textAlignment   = NSTextAlignmentRight;
            self.phoneLabel.backgroundColor = [UIColor clearColor];
            self.phoneLabel.font            = [UIFont systemFontOfSize:15.0f];
            self.phoneLabel.textColor       = [UIColor lightGrayColor];
            self.accessoryView = self.phoneLabel;
        }
    }
    return self;
}

@end
