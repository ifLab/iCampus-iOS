//
//  KMGradeResultCell.h
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-9-11.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMGradeResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseNameLable;
@property (weak, nonatomic) IBOutlet UILabel *usuallyGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *experimentalGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalGradeLabel;

@end
