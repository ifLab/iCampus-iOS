//
//  ICSchoolDetailView.m
//  iCampus
//
//  Created by Darren Liu on 13-12-23.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICSchoolDetailView.h"
#import "../../Model/School/ICSchoolDetail.h"

@implementation ICSchoolDetailView

- (id)initWithSchool:(ICSchool *)school
               frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if (self) {
        ICSchoolDetailView __weak *__self = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ICSchoolDetail *detail = [ICSchoolDetail schoolDetailWithSchool:school];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 10.0;
                if (!detail) {
                    return;
                }
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                               initWithString:detail.body];
                [attributedString addAttribute:NSParagraphStyleAttributeName
                                         value:paragraphStyle
                                         range:NSMakeRange(0, detail.body.length)];
                __self.bodyLabel.attributedText = attributedString;
                [__self.bodyLabel sizeToFit];
                __self.scrollView.contentSize = CGSizeMake(__self.scrollView.frame.size.width,
                                                           __self.bodyLabel.frame.size.height + 100.0);
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
            _bodyLabel = [[UILabel alloc] init]; {
                self.bodyLabel.frame         = CGRectMake(10.0, 20.0,
                                                          self.scrollView.frame.size.width - 20.0,
                                                          self.scrollView.frame.size.height - 40.0);
                self.bodyLabel.textColor     = [UIColor darkGrayColor];
                self.bodyLabel.font          = [UIFont systemFontOfSize:14.0];
                self.bodyLabel.numberOfLines = 0;
                self.bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [self.scrollView addSubview:self.bodyLabel];
            }
        }
    }
    return self;
}

@end
