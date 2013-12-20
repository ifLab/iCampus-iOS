//
//  ICBusStationCell.m
//  iCampus
//
//  Created by Darren Liu on 13-12-20.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICBusStationCell.h"
#import "../../Model/Bus/ICBus.h"

@implementation ICBusStationCell

- (id)initWithStationList:(ICBusStationList *)stationList
          reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setStationList:(ICBusStationList *)stationList {
    _stationList = stationList;
    CGFloat x=20.0;
    CGFloat height = 100.0; // height of cell is 120.0. But need 20 padding
    CGFloat width = 120.0;
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, (width-10.0)*self.stationList.count+40.0, height)];
    
    UIImageView *deprIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 45.0, 20.0, 20.0)];
    deprIcon.image = [UIImage imageNamed:@"SchoolBusTimeIcon.png"];
    [main addSubview:deprIcon];
    //[main addSubview:retnIcon];
    
    NSInteger count = self.stationList.count;
    for (int i = 0; i<count; i++) {
        ICBusStation *station = [self.stationList stationAtIndex:i];
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
        UILabel *stopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0, width - 20.0, 40.0)];
        UILabel *stopDeprLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 45.0, width - 20.0, 20.0)];
        stopNameLabel.textAlignment = NSTextAlignmentCenter;
        stopDeprLabel.textAlignment = NSTextAlignmentCenter;
        stopNameLabel.font = [UIFont systemFontOfSize:16.0];
        stopDeprLabel.font = [UIFont systemFontOfSize:14.0];
        stopNameLabel.textColor = [UIColor darkGrayColor];
        stopDeprLabel.textColor = [UIColor grayColor];
        container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusStationNormal"]];
        if (i == 0) {
            container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusStationFirst"]];
        }
        if (i == count - 1) {
            container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusStationLast"]];
        }
        stopNameLabel.numberOfLines = 2;
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        stopNameLabel.text = station.name;
        stopDeprLabel.text = [dateFormatter stringFromDate:station.time]==nil?@"-":[dateFormatter stringFromDate:station.time];
        //stopRetnLabel.text = [dateFormatter stringFromDate:stop.returnTime];
        //stopDeprLabel.text = @"11:25";
        //stopRetnLabel.text = @"16:00";
        [container addSubview:stopNameLabel];
        [container addSubview:stopDeprLabel];
        //[container addSubview:stopRetnLabel];
        [main addSubview:container];
        x += 110.0;
    }
}

@end
