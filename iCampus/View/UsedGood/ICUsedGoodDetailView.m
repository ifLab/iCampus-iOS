//
//  ICUsedGoodDetailView.m
//  iCampus
//
//  Created by EricLee on 14-4-8.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodDetailView.h"
#import "ICUsedGoodDetail.h"
#import "../../Model/ICModelConfig.h"

@interface ICUsedGoodDetailView ()
@property (nonatomic, strong) ICUsedGoodDetail *detailGood;

@end

@implementation ICUsedGoodDetailView


- (id)initWithUsedGood:(ICUsedGood *)good
                 frame:(CGRect)frame{
    self = [self initWithFrame:frame];
    if (self) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.detailGood=[[ICUsedGoodDetail alloc]initWithUsedGood:good];
            dispatch_async(dispatch_get_main_queue(),^{
                self.titleLabel.text=good.title ;
                NSString *dateString =good.time;
                self.timeLabel.text=dateString;
                self.bodyLabel.text=good.preview;
                self.authorLabel.text=good.author;
                // NSLog(@"%@",good.author);
                self.priceLabel.text=[NSString  stringWithFormat:  @"¥ %@" , good.price];
                self.priceLabel.shadowOffset = CGSizeMake(1, 1);
                self.priceLabel.shadowColor = [UIColor grayColor];
                self.bodyLabel.text=good.description;
                
                [self.bodyLabel sizeToFit];
                [self.bodyView sizeThatFits:CGSizeMake(self.scrollView.frame.size.width, self.bodyLabel.frame.size.height)];
                [self.scrollView sizeToFit];
                self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, self.bodyLabel.frame.size.height+self.headerView.frame.size.height+self.imagePager.frame.size.height+100);
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
            self.scrollView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:0.88];
            [self addSubview:self.scrollView];
            _imagePager = [[KIImagePager alloc] init]; {
                self.imagePager.frame                 = CGRectMake(0.0, 0.0, self.frame.size.width, 200.0);
                self.imagePager.delegate              = self;
                self.imagePager.dataSource            = self;
                self.imagePager.slideshowTimeInterval = 5.0f;
                self.imagePager.backgroundColor       = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
                [self.scrollView addSubview:self.imagePager];
            }
            _priceLabel  = [[UILabel alloc] init]; {
                self.priceLabel.frame=CGRectMake(80,130, 230, 50);
                self.priceLabel.font = [UIFont systemFontOfSize:36];
                self.priceLabel.textAlignment = NSTextAlignmentRight;
                self.priceLabel.textColor=[UIColor whiteColor];
                [self.scrollView addSubview:self.priceLabel];
            }


            _headerView = [[UIView       alloc] init]; {
                self.headerView.frame = CGRectMake(0, 199, self.scrollView.frame.size.width, 75.0);
                [self.scrollView addSubview:self.headerView];
                self.headerView.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];

                _titleLabel  = [[UILabel alloc] init]; {
                    self.titleLabel.frame         = CGRectMake(20.0, 10.0, 200, 40.0);
                    self.titleLabel.font          = [UIFont systemFontOfSize:18.0f];
                    self.titleLabel.textColor     = [UIColor darkTextColor];
                    self.titleLabel.numberOfLines = 1;
                    self.titleLabel.textAlignment = NSTextAlignmentLeft;
                    [self.headerView addSubview:self.titleLabel];
                }
                _timeLabel   = [[UILabel alloc] init]; {
                    self.timeLabel.frame         = CGRectMake(22.0, 45.0, self.scrollView.frame.size.width - 20.0, 20.0);
                    self.timeLabel.font          = [UIFont systemFontOfSize:12.0f];
                    self.timeLabel.textColor     = [UIColor lightGrayColor];
                    self.timeLabel.numberOfLines = 1;
                    self.timeLabel.textAlignment = NSTextAlignmentLeft;
                    [self.headerView addSubview:self.timeLabel];
                }
                _authorLabel = [[UILabel alloc]init];{
                    self.authorLabel.frame         =CGRectMake(180, 20, 80, 50);
                    self.authorLabel.font          = [UIFont systemFontOfSize:17.0f];
                    self.authorLabel.textColor     = [UIColor darkTextColor];
                    self.authorLabel.numberOfLines = 1;
                    self.authorLabel.textAlignment = NSTextAlignmentRight;
                    [self.headerView addSubview:self.authorLabel];
                }
                _detailButton=[[UIButton alloc]init];{
                self.detailButton =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                self.detailButton.frame=CGRectMake(self.authorLabel.frame.origin.x+75, self.authorLabel.frame.origin.y,50, 50);
                // [detail buttonType = UIButtonTypeDetailDisclosure];
                [self.headerView addSubview:self.detailButton];
                }
                
            }
            
                _bodyLabel   = [[UILabel alloc] init]; {
                    self.bodyLabel.frame         = CGRectMake(20,self.headerView.frame.origin.y+90, self.scrollView.frame.size.width-40,80.0);
                    self.bodyLabel.font          = [UIFont systemFontOfSize:15.0f];
                    self.bodyLabel.textColor     = [UIColor blackColor];
                    self.bodyLabel.textAlignment = NSTextAlignmentLeft;
                    self.bodyLabel.numberOfLines = 0;
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
    return self.detailGood.imageURLs;
}

- (UIViewContentMode)contentModeForImage:(NSUInteger)image {
    return UIViewContentModeScaleAspectFill;
}

- (UIImage *)placeHolderImageForImagePager {
    return [UIImage imageNamed:@"ICNewsDetailImagePlaceHolder"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
