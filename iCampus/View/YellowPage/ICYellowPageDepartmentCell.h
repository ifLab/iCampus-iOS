//
//  ICYellowPageDepartmentCell.h
//  iCampus
//
//  Created by Darren Liu on 14-1-26.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICYellowPageDepartment;

@interface ICYellowPageDepartmentCell : UITableViewCell

- (id)initWithDepartment:(ICYellowPageDepartment *)department
         reuseIdentifier:(NSString *)reuseIdentifier;

@end
