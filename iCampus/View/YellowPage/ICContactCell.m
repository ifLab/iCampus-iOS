//
//  ICContactCell.m
//  iCampus
//
//  Created by Darren Liu on 13-12-25.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICContactCell.h"
#import "../../Model/YellowPage/ICYellowPage.h"

@implementation ICContactCell

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
        self.frame = CGRectMake(0, 0, self.frame.size.width, 64.0);
        UIView *view = [[UIView alloc] init]; {
            view.frame           = CGRectMake(0, 0, self.frame.size.width, 28.0);
            view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            [self.contentView addSubview:view];
            _nameLabel   = [[UILabel alloc] init]; {
                self.nameLabel.frame     = CGRectMake(10.0, 0, self.frame.size.width - 10.0, 28.0);
                self.nameLabel.textColor = [UIColor darkTextColor];
                self.nameLabel.font      = [UIFont systemFontOfSize:14.0];
                [view addSubview:self.nameLabel];
            }
        }
        UIView *line = [[UIView  alloc] init]; {
            line.frame           = CGRectMake(0, 28.0, self.frame.size.width, 0.5);
            line.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            [self.contentView addSubview:line];
        }
        _phoneLabel  = [[UILabel alloc] init]; {
            self.phoneLabel.frame         = CGRectMake(10.0, 28.0, self.frame.size.width - 10.0, 36.0);
            self.phoneLabel.textColor     = [UIColor darkGrayColor];
            self.phoneLabel.font          = [UIFont systemFontOfSize:14.0];
            [self.contentView addSubview:self.phoneLabel];
            
        }
    }
    return self;
}

@end
