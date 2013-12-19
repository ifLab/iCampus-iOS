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

@property (nonatomic, strong) UILabel            *titleLabel     ;
@property (nonatomic, strong) UILabel            *bodyLabel      ;
@property (nonatomic, strong) UILabel            *timeLabel      ;
@property (nonatomic, strong) UIView             *headerView     ;
@property (nonatomic, strong) NSArray            *images         ;
@property (nonatomic, strong) UIScrollView       *scrollView     ;
@property (nonatomic, strong) ICNewsDetail       *newsDetail     ;
@property (nonatomic, strong) KIImagePager       *imagePager     ;

- (id)initWithNews:(ICNews *)news
             frame:(CGRect)frame;

@end
