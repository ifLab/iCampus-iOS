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
        self.textLabel.text = school.name;
    }
    return self;
}

@end
