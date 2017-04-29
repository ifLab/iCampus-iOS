//
//  PJAboutTableViewCell.h
//  iCampus
//
//  Created by #incloud on 2017/4/29.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJAboutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *aboutNameLabel;

@property (nonatomic, strong) NSDictionary *dataSource;
@end
