//
//  ICBusCell.h
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICBus;

@interface ICBusCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *busIcon           ;
@property (nonatomic, strong, readonly) UIImageView *departureIcon     ;
@property (nonatomic, strong, readonly) UIImageView *returnIcon        ;
@property (nonatomic, strong, readonly) UILabel     *nameLabel         ;
@property (nonatomic, strong, readonly) UILabel     *descriptionLabel  ;
@property (nonatomic, strong, readonly) UILabel     *departureTimeLabel;
@property (nonatomic, strong, readonly) UILabel     *returnTimeLabel   ;

- (id)initWithBus:(ICBus *)bus
  reuseIdentifier:(NSString *)reuseIdentifier;

@end
