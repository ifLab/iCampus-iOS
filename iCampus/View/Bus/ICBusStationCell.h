//
//  ICBusStationCell.h
//  iCampus
//
//  Created by Darren Liu on 13-12-20.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICBusStationList;

@interface ICBusStationCell : UITableViewCell

@property (nonatomic, strong) ICBusStationList *stationList;

- (id)initWithStationList:(ICBusStationList *)stationList
          reuseIdentifier:(NSString *)reuseIdentifier;

@end
