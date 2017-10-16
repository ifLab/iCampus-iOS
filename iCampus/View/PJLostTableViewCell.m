//
//  PJLostTableViewCell.m
//  iCampus
//
//  Created by #incloud on 2017/5/1.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "PJLostTableViewCell.h"
#import "ICNetworkManager.h"
#import "IDMPhoto.h"

@implementation PJLostTableViewCell
{
    NSArray *_kDataArr;   // 存储最终转化好的ImgURL
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 8;    // 减掉的值就是分隔线的高度
    [super setFrame:frame];
}

- (void)initView {
    _kDataArr = [@[] mutableCopy];
    _detailsLabel.font = [UIFont systemFontOfSize:14];
    _detailsLabel.textColor = [UIColor blackColor];
//    _nameLabel.textColor = [UIColor lightGrayColor];
//    _nameLabel.font = [UIFont systemFontOfSize:14];
//    _phoneLabel.textColor = [UIColor lightGrayColor];
//    _phoneLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
//    [_callBtn setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
//    [_callBtn setTitle:@"" forState:UIControlStateNormal];
//    [_callBtn addTarget:self action:@selector(callBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)callBtnClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _dataSource[@"phone"]]]];
}

- (void)setDataSource:(NSDictionary *)dataSource {
    _dataSource = dataSource;
    _detailsLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"details"]];
    _timeLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"createTime"]];
//    _nameLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"author"]];
//    _phoneLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"phone"]];
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
    for (UIView *view in self.showImgScrollView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat imgW = (SCREEN_WIDTH - 30) / 3;
    CGFloat imgH = imgW;
    _scrollViewHeighConstraint.constant = imgH + 10;
    CGFloat marginX = 7.5;
    int itemNums = 0;
    CGFloat lastItemMaxX = 0;
    CGFloat scViewWidth = 0;
    
    for (int i = 0; i < dataArr.count; i++) {
        CGFloat itemX = marginX + (imgH+marginX) * itemNums;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemX, 0, imgW, imgH)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = true;
        [imageView sd_setImageWithURL:[NSURL URLWithString:dataArr[i]] placeholderImage:[UIImage imageNamed:@"nopic"]];
        [self.showImgScrollView addSubview:imageView];
        itemNums++;
        lastItemMaxX = CGRectGetMaxX(imageView.frame);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = 100 + i;
        imageView.userInteractionEnabled = true;
        scViewWidth += imgW;
    }
    scViewWidth += 15;
    _scrollerViewWidth.constant = scViewWidth;
    self.showImgScrollView.showsHorizontalScrollIndicator = NO;
    [self.showImgScrollView setContentSize:CGSizeMake(lastItemMaxX, 0)];
}

-(void)clickImage:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    NSMutableArray *newArr = [[NSMutableArray alloc] init];
    for (NSString *str in _kDataArr) {
        [newArr addObject:str];
    }
    NSArray *photos = [IDMPhoto photosWithURLs:newArr];
    [_cellDelagate cellClick:photos index:tag];
}

@end
