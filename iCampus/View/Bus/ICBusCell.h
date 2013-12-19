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

@property (nonatomic, strong) UIImageView *busIcon           ;
@property (nonatomic, strong) UIImageView *departureIcon     ;
@property (nonatomic, strong) UIImageView *returnIcon        ;
@property (nonatomic, strong) UILabel     *nameLabel         ;
@property (nonatomic, strong) UILabel     *descriptionLabel  ;
@property (nonatomic, strong) UILabel     *departureTimeLabel;
@property (nonatomic, strong) UILabel     *returnTimeLabel   ;

- (id)initWithBus:(ICBus *)bus
  reuseIdentifier:(NSString *)reuseIdentifier;

@end
