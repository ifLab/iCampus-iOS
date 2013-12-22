//
//  ICSchoolCell.h
//  iCampus
//
//  Created by Darren Liu on 13-12-23.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICSchool;

@interface ICSchoolCell : UITableViewCell

- (id)initWithSchool:(ICSchool *)school
     reuseIdentifier:(NSString *)reuseIdentifier;

@end
