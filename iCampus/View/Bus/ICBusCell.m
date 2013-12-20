//
//  ICBusCell.m
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICBusCell.h"
#import "../../Model/Bus/ICBus.h"

@implementation ICBusCell

- (id)initWithBus:(ICBus *)bus
  reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:reuseIdentifier];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm";
        dateFormatter.timeZone   = [NSTimeZone localTimeZone];
        self.nameLabel.text          = bus.name;
        self.descriptionLabel.text   = bus.description;
        self.departureTimeLabel.text = (bus.departureTime)? [dateFormatter stringFromDate:bus.departureTime] : @"-";
        self.returnTimeLabel.text    = (bus.returnTime)? [dateFormatter stringFromDate:bus.returnTime] : @"-";
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.busIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18.0, 18.0, 36.0, 36.0)];
        self.busIcon.image = [UIImage imageNamed:@"ICBusIcon"];
        [self.contentView addSubview:self.busIcon];
        self.nameLabel           = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 15.0, 180.0, 24.0)];
        self.nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.nameLabel.font      = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.nameLabel];
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 36.0, 180.0, 20.0)];
        self.descriptionLabel.textColor = [UIColor grayColor];
        self.descriptionLabel.font      = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.descriptionLabel];
        self.departureTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0, 18.0, 55.0, 16.0)];
        self.departureTimeLabel.textColor     = [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1.0];
        self.departureTimeLabel.font          = [UIFont systemFontOfSize:14.0];
        self.departureTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.departureTimeLabel];
        self.returnTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0, 37.0, 55.0, 16.0)];
        self.returnTimeLabel.textColor       = [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1.0];
        self.returnTimeLabel.font            = [UIFont systemFontOfSize:14.0];
        self.returnTimeLabel.textAlignment   = NSTextAlignmentCenter;
        [self.contentView addSubview:self.returnTimeLabel];
        self.departureIcon = [[UIImageView alloc] initWithFrame:CGRectMake(245.0, 18.0, 16.0, 16.0)];
        self.departureIcon.image = [UIImage imageNamed:@"ICBusDepartIcon"];
        [self.contentView addSubview:self.departureIcon];
        self.returnIcon = [[UIImageView alloc] initWithFrame:CGRectMake(245.0, 37.0, 16.0, 16.0)];
        self.returnIcon.image = [UIImage imageNamed:@"ICBusReturnIcon"];
        [self.contentView addSubview:self.returnIcon];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 71.0, 320.0, 1.0)];
        line.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [self.contentView addSubview:line];
    }
    return self;
}

@end
