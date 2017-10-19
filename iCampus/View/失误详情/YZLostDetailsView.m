//
//  YZLostDetailsView.m
//  iCampus
//
//  Created by 戚译中 on 2017/9/30.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "YZLostDetailsView.h"
#import "ICNetworkManager.h"
#import "IDMPhoto.h"

@implementation YZLostDetailsView{
    CGFloat _kTextHeight;
    UILabel* _kDetailsLabel;
    CGRect textFrame;
    NSArray *_kImageUrlArray;
}

- (instancetype)init {
    self = [super init];
    [self setupUI];
    return self;
}

- (void) setupUI{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor grayColor];
    
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 12, self.frame.size.width, SCREEN_HEIGHT - 64)];
    _scrollview.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollview];
    
    _phoneLabel = [[UILabel alloc]init];
    _phoneLabel.frame = CGRectMake(0, SCREEN_HEIGHT-54, SCREEN_WIDTH, 27);
    [_phoneLabel setBackgroundColor:RGB(245, 245, 245)];
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_phoneLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.frame = CGRectMake(0, SCREEN_HEIGHT-27, SCREEN_WIDTH, 27);
    [_timeLabel setBackgroundColor:RGB(245, 245, 245)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];
    
    _kDetailsLabel = [[UILabel alloc]init];
    _kDetailsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _kDetailsLabel.font = [UIFont systemFontOfSize:14.0f];
    _kDetailsLabel.numberOfLines = 0;
    [_scrollview addSubview:_kDetailsLabel];
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
    _kImageUrlArray = [newArr mutableCopy];
    return newArr;
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    NSString *phoneStr = @"电话:";
    _phoneLabel.text = [phoneStr stringByAppendingString:[NSString stringWithFormat:@"%@", dataSource[@"phone"]]];
    _timeLabel.text = [NSString stringWithFormat:@"%@",dataSource[@"createTime"]];
    _imageArray = [self setupImgArr:[NSString stringWithFormat:@"%@", dataSource[@"imgUrlList"]]];
    _kDetailsLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"details"]];
    //label自适应高度
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_kDetailsLabel.font,NSFontAttributeName, nil];
    textFrame = _kDetailsLabel.frame;
    textFrame.size.height = [_kDetailsLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-8, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    _kDetailsLabel.frame = CGRectMake(4, 0, SCREEN_WIDTH-8, textFrame.size.height);
    _kTextHeight = textFrame.size.height;
    long k = _imageArray.count;
    CGFloat lastY = _kTextHeight + 8 + 308*k;
    //设置contenSize符合整个页面所有控件加起来的长度
    _scrollview.contentSize = CGSizeMake(0, lastY);
    [self setupScrollView:dataSource];
}

- (void)setupScrollView:(NSDictionary *)data{
    NSArray* imgArry = _imageArray;
    CGFloat y = textFrame.size.height;
    CGFloat spaceY = 8;
    int imageNum = 0;
    CGFloat lastY = y;
    for (int i=0; i<imgArry.count; i++) {
        CGFloat viewY = y + spaceY + 308*imageNum;
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, viewY, SCREEN_WIDTH-8, 300)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgArry[i]] placeholderImage:[UIImage imageNamed:@"nopic"]];
        [_scrollview addSubview:imageView];
        imageNum++;
        lastY = viewY;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDetailsImage:)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = 100+i;
        imageView.userInteractionEnabled = YES;
    }
}

- (void)clickDetailsImage:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    NSMutableArray* newArray = [[NSMutableArray alloc]init];
    for (NSString* str in _kImageUrlArray) {
        [newArray addObject:str];
    }
    NSArray* array = [IDMPhoto photosWithURLs:newArray];
    [_LostDetailsViewDelegate clickImage:array andTag:tag];
}

@end
