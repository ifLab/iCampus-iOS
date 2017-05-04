//
//  PJMyPublishLostTableViewCell.m
//  iCampus
//
//  Created by #incloud on 2017/5/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJMyPublishLostTableViewCell.h"

@implementation PJMyPublishLostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {
    
}

- (void)initScrollView:(NSArray *)dataArr {
    for (UIView *view in self.imgScrollView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat imgW = (SCREEN_WIDTH - 30) / 3;
    CGFloat imgH = imgW;
    CGFloat marginX = 7.5;
    int itemNums = 0;
    CGFloat lastItemMaxX = 0;
    
    for (int i = 0; i < dataArr.count; i++) {
        CGFloat itemX = marginX + (imgH+marginX) * itemNums;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemX, 0, imgW, imgH)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = true;
        [imageView sd_setImageWithURL:[NSURL URLWithString:dataArr[i]]];
        [self.imgScrollView addSubview:imageView];
        itemNums++;
        lastItemMaxX = CGRectGetMaxX(imageView.frame);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = 100 + i;
        imageView.userInteractionEnabled = true;
    }
    self.imgScrollView.showsHorizontalScrollIndicator = NO;
    [self.imgScrollView setContentSize:CGSizeMake(lastItemMaxX, 0)];
}

-(void)clickImage:(UITapGestureRecognizer *)tap{
    
}

@end
