//
//  ICUsedGoodFilterTableViewCell.m
//  iCampus
//
//  Created by EricLee on 14-6-6.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodFilterTableViewCell.h"
#import "ICUsedGoodType.h"
@implementation ICUsedGoodFilterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithType:(ICUsedGoodType *)type reuseIdentifier:(NSString *)reuseIdentifier{
    self=[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *typeName = [[UILabel alloc]initWithFrame:self.frame];
        typeName.text=type.name;
        typeName.textColor=[UIColor blackColor];
        typeName.textAlignment=NSTextAlignmentCenter;
        [self addSubview:typeName];
        self.type=type;
    }  
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
