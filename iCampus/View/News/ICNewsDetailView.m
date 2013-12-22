//
//  ICNewsDetailView.m
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsDetailView.h"
#import "ICNews.h"

@interface ICNewsDetailView ()

@property (nonatomic, strong) ICNewsDetail *newsDetail;

@end

@implementation ICNewsDetailView

- (id)initWithNews:(ICNews *)news
             frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if (self) {
        ICNewsDetailView __weak *__self = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __self.newsDetail = [ICNewsDetail newsDetailWithNews:news];
            dispatch_async(dispatch_get_main_queue(), ^{
                __self.titleLabel.text = __self.newsDetail.title;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.timeZone = [NSTimeZone localTimeZone];
                dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                __self.timeLabel.text = [dateFormatter stringFromDate:__self.newsDetail.creationTime];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 10.0;
                if (!__self.newsDetail) {
                    return;
                }
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                               initWithString:__self.newsDetail.body];
                [attributedString addAttribute:NSParagraphStyleAttributeName
                                         value:paragraphStyle
                                         range:NSMakeRange(0, __self.newsDetail.body.length)];
                __self.bodyLabel.attributedText = attributedString;
                [__self.bodyLabel sizeToFit];
                __self.scrollView.contentSize = CGSizeMake(__self.scrollView.frame.size.width,
                                                           __self.bodyLabel.frame.size.height + 365.0);
                [__self.imagePager reloadData];
            });
        });
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init]; {
            self.scrollView.frame = self.frame;
            [self addSubview:self.scrollView];
            _imagePager = [[KIImagePager alloc] init]; {
                self.imagePager.frame                 = CGRectMake(0.0, 0.0, self.frame.size.width, 200.0);
                self.imagePager.delegate              = self;
                self.imagePager.dataSource            = self;
                self.imagePager.slideshowTimeInterval = 5.0f;
                self.imagePager.backgroundColor       = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
                [self.scrollView addSubview:self.imagePager];
            }
            _headerView = [[UIView       alloc] init]; {
                self.headerView.frame = CGRectMake(0, 200, self.scrollView.frame.size.width, 75.0);
                [self.scrollView addSubview:self.headerView];
                _titleLabel  = [[UILabel alloc] init]; {
                    self.titleLabel.frame         = CGRectMake(10.0, 10.0, self.scrollView.frame.size.width - 20.0, 40.0);
                    self.titleLabel.font          = [UIFont systemFontOfSize:18.0f];
                    self.titleLabel.textColor     = [UIColor darkTextColor];
                    self.titleLabel.numberOfLines = 1;
                    self.titleLabel.textAlignment = NSTextAlignmentLeft;
                    [self.headerView addSubview:self.titleLabel];
                }
                _timeLabel   = [[UILabel alloc] init]; {
                    self.timeLabel.frame         = CGRectMake(12.0, 45.0, self.scrollView.frame.size.width - 20.0, 20.0);
                    self.timeLabel.font          = [UIFont systemFontOfSize:12.0f];
                    self.timeLabel.textColor     = [UIColor lightGrayColor];
                    self.timeLabel.numberOfLines = 1;
                    self.timeLabel.textAlignment = NSTextAlignmentLeft;
                    [self.headerView addSubview:self.timeLabel];
                }
                UIView *line = [[UIView  alloc] init]; {
                    line.frame = CGRectMake(20.0, self.headerView.frame.size.height, self.scrollView.frame.size.width - 40.0, 1.0);
                    line.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
                    [self.headerView addSubview:line];
                }
            }
            _bodyLabel  = [[UILabel      alloc] init]; {
                self.bodyLabel.frame         = CGRectMake(10.0, self.headerView.frame.size.height + self.headerView.frame.origin.y + 15.0,
                                                          self.scrollView.frame.size.width - 20.0, self.frame.size.height);
                self.bodyLabel.font          = [UIFont systemFontOfSize:14.0];
                self.bodyLabel.textColor     = [UIColor darkGrayColor];
                self.bodyLabel.numberOfLines = 0;
                self.bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [self.scrollView addSubview:self.bodyLabel];
            }
        }
    }
    return self;
}

- (NSString *)captionForImageAtIndex:(NSUInteger)index {
    return nil;
}

- (NSArray *)arrayWithImages {
    return self.newsDetail.imageURLs;
}

- (UIViewContentMode)contentModeForImage:(NSUInteger)image {
    return UIViewContentModeScaleAspectFill;
}

- (UIImage *)placeHolderImageForImagePager {
    return [UIImage imageNamed:@"ICNewsDetailImagePlaceHolder"];
}

@end
