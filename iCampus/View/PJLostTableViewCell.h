//
//  PJLostTableViewCell.h
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJLostTableViewCellDelegate <NSObject>

- (void)cellClick:(NSArray *)data index:(NSInteger)index;

@end

@interface PJLostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *showImgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeighConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerViewWidth;

@property (nonatomic, strong) NSDictionary *dataSource;

@property (nonatomic, weak) id<PJLostTableViewCellDelegate> cellDelagate;
@end
