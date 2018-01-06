//
//  PJYellowPageTableViewCell.h
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJYellowPageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) NSDictionary *cellDataSource;

@end
