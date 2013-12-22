//
//  ICNewsCell.h
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICNews;

@interface ICNewsCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *thumbnailImageView;
@property (nonatomic, strong, readonly) UILabel     *previewLabel      ;
@property (nonatomic, strong, readonly) UILabel     *titleLabel        ;

- (id)initWithNews:(ICNews *)news
   reuseIdentifier:(NSString *)reuseIdentifier;

@end
