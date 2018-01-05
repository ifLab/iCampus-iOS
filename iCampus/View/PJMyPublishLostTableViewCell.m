//
//  PJMyPublishLostTableViewCell.m
//  iCampus
//
//  Created by #incloud on 2017/5/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJMyPublishLostTableViewCell.h"
#import "ICNetworkManager.h"
#import "IDMPhoto.h"

@implementation PJMyPublishLostTableViewCell {
    NSArray *_kDataArr;   // 存储最终转化好的ImgURLz
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setDataSource:(NSDictionary *)dataSource {
    _detailsLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"details"]];
    _timeLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"createTime"]];
    
    [self initScrollView:[self setupImgArr:dataSource[@"imgUrlList"]]];
}

- (NSArray *)setupImgArr:(NSString *)imgURL {
    NSMutableArray *newArr = [@[] mutableCopy];
    NSData *jsonData = [imgURL dataUsingEncoding:NSUTF8StringEncoding];
    NSArray * dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    for (int i = 0; i < dataArr.count; i++) {
        NSString *webSite = [ICNetworkManager defaultManager].website;
        webSite = [NSString stringWithFormat:@"%@%@?api_key=%@&session_token=%@", webSite, dataArr[i][@"url"], [ICNetworkManager defaultManager].APIKey, [ICNetworkManager defaultManager].token];
        [newArr addObject:webSite];
    }
    _kDataArr = [newArr mutableCopy];
    return newArr;
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
        [imageView sd_setImageWithURL:[NSURL URLWithString:dataArr[i]] placeholderImage:[UIImage imageNamed:@"nopic"]];
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
    NSInteger tag = tap.view.tag;
    NSMutableArray *newArr = [[NSMutableArray alloc] init];
    for (NSString *str in _kDataArr) {
        [newArr addObject:str];
    }
    NSArray *photos = [IDMPhoto photosWithURLs:newArr];
    [_cellDelegate cellClick:photos index:tag];
}

@end
