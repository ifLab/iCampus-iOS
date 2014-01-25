//
//  ICYellowPageContactCell.h
//  iCampus
//
//  Created by Darren Liu on 13-12-25.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICYellowPageContact;

@interface ICYellowPageContactCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel ;
@property (nonatomic, strong, readonly) UILabel *phoneLabel;

- (id)initWithContact:(ICYellowPageContact *)contact
      reuseIdentifier:(NSString *)reuseIdentifier;

@end
