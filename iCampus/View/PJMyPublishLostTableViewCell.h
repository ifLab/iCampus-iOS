//
//  PJMyPublishLostTableViewCell.h
//  iCampus
//
//  Created by #incloud on 2017/5/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PJMyPublishLostTableViewCellDelegate <NSObject>

- (void)cellClick:(NSArray *)data index:(NSInteger)index;
- (void)trashClick:(NSIndexPath*)indexPath;

@end

@interface PJMyPublishLostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSDictionary *dataSource;

@property (nonatomic, weak) id<PJMyPublishLostTableViewCellDelegate> cellDelegate;

@end
