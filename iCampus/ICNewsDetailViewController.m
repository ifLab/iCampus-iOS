//
//  ICNewsDetailViewController.m
//  iCampus
//
//  Created by Kwei Ma on 13-11-11.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsDetailViewController.h"

#import "ICNews.h"
#import "ICNewsDetail.h"

@interface ICNewsDetailViewController ()

@property (strong, nonatomic) UILabel *loadingLabel;
@property CGFloat accumulatedHeight;

@end

@implementation ICNewsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.height/2, self.view.frame.size.width/2, 320.0, 40.0)];
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.textColor = [UIColor grayColor];
    self.loadingLabel.text = @"正在加载";
    [self.view addSubview:self.loadingLabel];
    
    //__weak ICNewsDetailViewController *weakSelf = self;
    
    CGSize mainSize = self.scrollView.frame.size;
    UILabel *newsTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, mainSize.width - 20, CGFLOAT_MIN)];
    newsTitle.font = [UIFont systemFontOfSize:22.0f];
    newsTitle.textColor = [UIColor darkTextColor];
    newsTitle.numberOfLines = 0;
    newsTitle.textAlignment = NSTextAlignmentLeft;
    newsTitle.text = self.news.title;
    [newsTitle sizeToFit];
    [self.scrollView addSubview:newsTitle];
    
    self.accumulatedHeight += newsTitle.frame.size.height + 40;
    
    UILabel *newsBody = [[UILabel alloc] initWithFrame:CGRectMake(10, self.accumulatedHeight, mainSize.width - 20, mainSize.height)];
    newsBody.font = [UIFont systemFontOfSize:16.0f];
    newsBody.textColor = [UIColor darkGrayColor];
    newsBody.numberOfLines = 0;
    newsBody.lineBreakMode = NSLineBreakByWordWrapping;
    [self.scrollView addSubview:newsBody];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        ICNewsDetail *newsDetail = [ICNewsDetail newsDetailWithNews:self.news];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:newsDetail.body];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:10.0];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [newsDetail.body length])];
            newsBody.attributedText = attributedString;
            [newsBody sizeToFit];
            
            self.accumulatedHeight += newsBody.frame.size.height + 10;
            
            self.scrollView.contentSize = CGSizeMake(mainSize.width, self.accumulatedHeight);
            
            [self.loadingLabel removeFromSuperview];
        });
    });
}

@end
