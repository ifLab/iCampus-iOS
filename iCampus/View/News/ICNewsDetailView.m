//
//  ICNewsDetailView.m
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsDetailView.h"
#import "ICNews.h"
#import "ICNewsDetail.h"

@interface ICNewsDetailView ()

@end

@implementation ICNewsDetailView

- (id)initWithNews:(ICNews *)news
             frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if (self) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
            self.newsDetail = [ICNewsDetail newsDetailWithNews:news];
            ICNewsDetailView __weak *__self = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.titleLabel.text = self.newsDetail.title;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.timeZone = [NSTimeZone localTimeZone];
                dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                self.timeLabel.text = [dateFormatter stringFromDate:self.newsDetail.creationTime];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 10.0;
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:__self.newsDetail.body];
                [attributedString addAttribute:NSParagraphStyleAttributeName
                                         value:paragraphStyle
                                         range:NSMakeRange(0, __self.newsDetail.body.length)];
                __self.bodyLabel.attributedText = attributedString;
                [__self.bodyLabel sizeToFit];
                __self.scrollView.contentSize = CGSizeMake(__self.scrollView.frame.size.width, __self.bodyLabel.frame.size.height + 165.0);
            });
        });
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        [self addSubview:self.scrollView];
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 75.0)];
        [self.scrollView addSubview:self.headerView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, self.scrollView.frame.size.width - 20.0, 40.0)];
        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.headerView addSubview:self.titleLabel];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 45.0, self.scrollView.frame.size.width - 20.0, 20)];
        self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.numberOfLines = 1;
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.headerView addSubview:self.timeLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20.0, self.headerView.frame.size.height, self.scrollView.frame.size.width - 40.0, 1.0)];
        line.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        [self.headerView addSubview:line];
        self.bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, self.headerView.frame.size.height + 15.0, self.scrollView.frame.size.width - 20.0, self.frame.size.height)];
        self.bodyLabel.font = [UIFont systemFontOfSize:14.0f];
        self.bodyLabel.textColor = [UIColor darkGrayColor];
        self.bodyLabel.numberOfLines = 0;
        self.bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.scrollView addSubview:self.bodyLabel];
    }
    return self;
}

@end
