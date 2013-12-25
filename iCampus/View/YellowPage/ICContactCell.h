//
//  ICContactCell.h
//  iCampus
//
//  Created by Darren Liu on 13-12-25.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICYellowPageContact;

@interface ICContactCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *phoneLabel;
@property (nonatomic, strong, readonly) UILabel *nameLabel ;

- (id)initWithContact:(ICYellowPageContact *)contact
      reuseIdentifier:(NSString *)reuseIdentifier;

@end
