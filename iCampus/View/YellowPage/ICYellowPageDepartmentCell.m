//
//  ICYellowPageDepartmentCell.m
//  iCampus
//
//  Created by Darren Liu on 14-1-26.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICYellowPageDepartmentCell.h"
#import "../../Model/YellowPage/ICYellowPage.h"

@implementation ICYellowPageDepartmentCell

- (id)initWithDepartment:(ICYellowPageDepartment *)department
         reuseIdentifier:(NSString *)reuseIdentifier; {
    self = [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.text = department.name;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *textLabel = self.textLabel; {
            textLabel.font          = [UIFont systemFontOfSize:16.0];
        }
    }
    return self;
}

@end
