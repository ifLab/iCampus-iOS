//
//  PJBusDetailsTableViewCell.h
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    blueType,    // 出发样式
    redType    // 返程样式
} PJBusDetailsTableViewCellType;

@interface PJBusDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic) PJBusDetailsTableViewCellType type;

@end
