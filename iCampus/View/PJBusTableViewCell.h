//
//  PJBusTableViewCell.h
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJBusTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *busNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *busTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *busTypeImage;

@property (nonatomic, strong) NSDictionary *cellDataSource;
@end
