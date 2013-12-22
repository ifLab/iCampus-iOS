//
//  ICSchoolDetailView.h
//  iCampus
//
//  Created by Darren Liu on 13-12-23.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICSchool;

@interface ICSchoolDetailView : UIView

@property (nonatomic, strong, readonly) UILabel      *bodyLabel ;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

- (id)initWithSchool:(ICSchool *)school
               frame:(CGRect)frame;

@end
