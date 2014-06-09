//
//  ICUsedGoodListCell.h
//  iCampus
//
//  Created by EricLee on 14-4-8.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICUsedGood;

@interface ICUsedGoodListCell : UITableViewCell
@property (nonatomic, strong, readonly) UIImageView *thumbnailImageView;
@property (nonatomic, strong, readonly) UILabel     *previewLabel      ;
@property (nonatomic, strong, readonly) UILabel     *titleLabel        ;
@property (nonatomic, strong, readonly) UILabel     *priceLabel        ;

- (id)initWithUsedGood:(ICUsedGood *)usedGood
   reuseIdentifier:(NSString *)reuseIdentifier;

@end
