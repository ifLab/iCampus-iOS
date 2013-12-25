//
//  ICSchoolCell.m
//  iCampus
//
//  Created by Darren Liu on 13-12-23.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICSchoolCell.h"
#import "../../Model/School/ICSchool.h"

@implementation ICSchoolCell

- (id)initWithSchool:(ICSchool *)school
     reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel.text = school.name;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel   = [[UILabel alloc] init]; {
            self.nameLabel.frame         = CGRectMake(0, 0, self.frame.size.width, 56.0);
            self.nameLabel.font          = [UIFont systemFontOfSize:16.0];
            self.nameLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:self.nameLabel];
        }
    }
    return self;
}

@end
