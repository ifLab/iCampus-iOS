//
//  ICNewsDetailView.h
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"

@class ICNews, ICNewsDetail;

@interface ICNewsDetailView : UIView <KIImagePagerDelegate, KIImagePagerDataSource>

@property (nonatomic, strong, readonly) UILabel      *titleLabel;
@property (nonatomic, strong, readonly) UILabel      *bodyLabel ;
@property (nonatomic, strong, readonly) UILabel      *timeLabel ;
@property (nonatomic, strong, readonly) UIView       *headerView;
@property (nonatomic, strong, readonly) NSArray      *images    ;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) KIImagePager *imagePager;

- (id)initWithNews:(ICNews *)news
             frame:(CGRect)frame;

@end
