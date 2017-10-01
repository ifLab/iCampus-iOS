//
//  YZLostDetailsView.m
//  iCampus
//
//  Created by 戚译中 on 2017/9/30.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "YZLostDetailsView.h"
#import "ICNetworkManager.h"

@implementation YZLostDetailsView{
    CGFloat _textHeight;
    UILabel* _detailsLabel;
    CGRect textFrame;
}

- (instancetype)init {
    self = [super init];
    [self setupUI];
    return self;
}

- (void) setupUI{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, SCREEN_HEIGHT - 64)];
    [self addSubview:_scrollview];
    
    _TimeAndPhoneLabel = [[UILabel alloc]init];
    _TimeAndPhoneLabel.frame = CGRectMake(0, SCREEN_HEIGHT-54, SCREEN_WIDTH-108, 54);
    [_TimeAndPhoneLabel setBackgroundColor:[UIColor grayColor]];
    [self addSubview:_TimeAndPhoneLabel];
    
    _detailsLabel = [[UILabel alloc]init];
    _detailsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _detailsLabel.font = [UIFont systemFontOfSize:14.0f];
    _detailsLabel.numberOfLines = 0;
    [_scrollview addSubview:_detailsLabel];
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
    return newArr;
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    _TimeAndPhoneLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"phone"]];
    _imageArray = [self setupImgArr:[NSString stringWithFormat:@"%@", dataSource[@"imgUrlList"]]];
    _detailsLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"details"]];
    //label自适应高度
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_detailsLabel.font,NSFontAttributeName, nil];
    textFrame = _detailsLabel.frame;
    textFrame.size.height = [_detailsLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-8, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    _detailsLabel.frame = CGRectMake(4, 0, SCREEN_WIDTH-8, textFrame.size.height);
    _textHeight = textFrame.size.height;
    long k = _imageArray.count;
    CGFloat lastY = _textHeight + 8 + 308*k;
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
    }
//    _scrollview.contentSize = CGSizeMake(0, lastY);
}

@end
