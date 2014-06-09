//
//  ICUsedGoodFilterTableViewCell.h
//  iCampus
//
//  Created by EricLee on 14-6-6.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICUsedGoodType;
@interface ICUsedGoodFilterTableViewCell : UITableViewCell
@property (nonatomic,strong) ICUsedGoodType *type;
- (id)initWithType:(ICUsedGoodType *)type reuseIdentifier:(NSString *)reuseIdentifier;
@end
