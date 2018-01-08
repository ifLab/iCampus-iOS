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

@interface YZLostDetailsView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;

@end

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
    self.backgroundColor = [UIColor whiteColor];
    
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, SCREEN_HEIGHT - 64)];
    _scrollview.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollview];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH, 10)];
    [self.scrollview addSubview:self.nameLabel];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.numberOfLines = 0;
    
    _kDetailsLabel = [[UILabel alloc]init];
    _kDetailsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _kDetailsLabel.font = [UIFont systemFontOfSize:15.0f];
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
    self.nameLabel.text = [NSString stringWithFormat:@"%@在%@发布了:", dataSource[@"author"], dataSource[@"createTime"]];
    [self.nameLabel sizeToFit];
    
    _imageArray = [self setupImgArr:[NSString stringWithFormat:@"%@", dataSource[@"imgUrlList"]]];
    _kDetailsLabel.text = [NSString stringWithFormat:@"%@", dataSource[@"details"]];
    //label自适应高度
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_kDetailsLabel.font,NSFontAttributeName, nil];
    textFrame = _kDetailsLabel.frame;
    textFrame.size.height = [_kDetailsLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-8, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    _kDetailsLabel.frame = CGRectMake(15, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 20, SCREEN_WIDTH-30, textFrame.size.height);
    
    _kTextHeight = textFrame.size.height;
    long k = _imageArray.count;
    CGFloat lastY = _kTextHeight + 308*k + self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + _kDetailsLabel.frame.origin.y + _kDetailsLabel.frame.size.height;
    
    //设置contenSize符合整个页面所有控件加起来的长度
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, lastY);
    [self setupScrollView:dataSource scrollView:_scrollview];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lastY - 25, SCREEN_WIDTH, 10)];
    [_scrollview addSubview:tipsLabel];
    tipsLabel.text = @"小主人一定很着急，快帮忙扩散消息啦~";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.font = [UIFont boldSystemFontOfSize:12];
}

- (void)setupScrollView:(NSDictionary *)data scrollView:(UIScrollView *)scrollView{
    NSArray* imgArry = _imageArray;
    CGFloat y = textFrame.size.height + _kDetailsLabel.frame.origin.y + 15;
    CGFloat spaceY = 8;
    int imageNum = 0;
    CGFloat lastY = y;
    for (int i=0; i<imgArry.count; i++) {
        CGFloat viewY = y + spaceY + 308*imageNum;
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, viewY, SCREEN_WIDTH-8, 300)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgArry[i]] placeholderImage:[UIImage imageNamed:@"nopic"]];
        [scrollView addSubview:imageView];
        imageNum++;
        lastY = viewY;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDetailsImage:)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = 100+i;
        imageView.userInteractionEnabled = YES;
    }
}

- (UIImageView *)captureScreenScrollView:(UIScrollView *)scrollView {
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;

    scrollView.frame = CGRectMake(0, scrollView.frame.origin.y, scrollView.contentSize.width, scrollView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 0.0);
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    UIGraphicsEndImageContext();

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)];
    imageView.image = image;
    
    return imageView;
}

- (UIImage *)shareImage {
    UIScrollView *tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tempScrollView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
    [tempScrollView addSubview:titleLabel];
    titleLabel.text = @"iBistu 失物";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width / 2 - 50 - 45, titleLabel.frame.origin.y + 5, 40, 40)];
    titleImageView.image = [UIImage imageNamed:@"logo"];
    [tempScrollView addSubview:titleImageView];
    
    UIImageView *contentImageView = [self captureScreenScrollView:_scrollview];
    contentImageView.frame = CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, contentImageView.frame.size.width, contentImageView.frame.size.height);
    [tempScrollView addSubview:contentImageView];
    
    UIImageView *QRCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, contentImageView.frame.size.height + 80, 100, 100)];
    QRCodeImageView.image = [UIImage imageNamed:@"QRcode"];
    [tempScrollView addSubview:QRCodeImageView];
    
    tempScrollView.contentSize = CGSizeMake(contentImageView.frame.size.width, contentImageView.frame.size.height + 230);
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = @"下载iBistu，帮失物找到小主人~";
    tipsLabel.textColor = [UIColor blackColor];
    tipsLabel.font = [UIFont boldSystemFontOfSize:14];
    [tipsLabel sizeToFit];
    tipsLabel.frame = CGRectMake((tempScrollView.frame.size.width - tipsLabel.frame.size.width)/2, tempScrollView.contentSize.height - 30, tipsLabel.frame.size.width, 15);
    [tempScrollView addSubview:tipsLabel];
    
    return [self captureScreenScrollView:tempScrollView].image;
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
