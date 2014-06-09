//
//  ICUsedGoodDetailView.h
//  iCampus
//
//  Created by EricLee on 14-4-8.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"

@class ICUsedGood,ICUsedGoodDetail;
@interface ICUsedGoodDetailView : UIView<KIImagePagerDelegate, KIImagePagerDataSource>

@property (nonatomic, strong, readonly) UILabel      *titleLabel;
@property (nonatomic, strong, readonly) UILabel      *bodyLabel ;
@property (nonatomic, strong, readonly) UILabel      *timeLabel ;
@property (nonatomic, strong, readonly) UILabel      *priceLabel;
@property (nonatomic, strong, readonly) UILabel      *authorLabel;
@property (nonatomic, strong, readonly) UIView       *headerView;
@property (nonatomic, strong, readonly) NSArray      *images    ;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) KIImagePager  *imagePager;
@property (nonatomic, strong, readonly) UIView       *bodyView;
@property (nonatomic, strong)           UIButton     *detailButton;
@property (nonatomic, strong)           UIBarButtonItem *del;
- (id)initWithUsedGood:(ICUsedGood *)good
                 frame:(CGRect)frame;

@end