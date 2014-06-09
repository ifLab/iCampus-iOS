//
//  ICUsedGoodListCell.m
//  iCampus
//
//  Created by EricLee on 14-4-8.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodListCell.h"
#import "../../External/UIKit+AFNetworking/UIImageView+AFNetworking.h"
#import "ICUsedGood.h"
@implementation ICUsedGoodListCell

-(id)initWithUsedGood:(ICUsedGood *)usedGood
      reuseIdentifier:(NSString *)reuseIdentifier{
    self=[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
    
        self.titleLabel.text=usedGood.title;
        self.previewLabel.text=usedGood.preview;
        self.priceLabel.text=[NSString  stringWithFormat:  @"¥ %@" , usedGood.price];
        ICUsedGoodListCell __weak *__self = self;
        [self.thumbnailImageView setImageWithURLRequest:[NSURLRequest requestWithURL:(usedGood.imageURLs[0])]
                                   placeholderImage:[UIImage imageNamed:@"ICNewsDetailImagePlaceHolder"]
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                __self.thumbnailImageView.image = image;
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                __self.thumbnailImageView.image = [UIImage imageNamed:@"ICNewsDetailImagePlaceHolder"];
                                            }];
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbnailImageView = [[UIImageView alloc] init]; {
            self.thumbnailImageView.frame           = CGRectMake(10.0, 10.0, 66.7, 50.0);
            self.thumbnailImageView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
            self.thumbnailImageView.contentMode     = UIViewContentModeScaleAspectFill;
            self.thumbnailImageView.clipsToBounds   = YES;
            [self.contentView addSubview:self.thumbnailImageView];
        }
        _titleLabel         = [[UILabel     alloc] init]; {
            self.titleLabel.frame     = CGRectMake(86.0, 12.0, 200, 18.0);
            self.titleLabel.font      = [UIFont systemFontOfSize:16.0];
            self.titleLabel.textColor = [UIColor darkTextColor];
            [self.contentView addSubview:self.titleLabel];
        }
        _priceLabel         = [[UILabel     alloc] init]; {
            self.priceLabel.frame     = CGRectMake(180, 40.0, 100, 18.0);
            self.priceLabel.font      = [UIFont systemFontOfSize:16.0];
            self.priceLabel.textColor = [UIColor darkTextColor];
            self.priceLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:self.priceLabel];
        }

//        _previewLabel       = [[UILabel     alloc] init];{
//            self.previewLabel.frame         = CGRectMake(86.0, 22.0, 224.0, 50.0);
//            self.previewLabel.font          = [UIFont systemFontOfSize:12.0];
//            self.previewLabel.numberOfLines = 2;
//            self.previewLabel.lineBreakMode = NSLineBreakByCharWrapping;
//            self.previewLabel.textColor     = [UIColor grayColor];
//            [self.contentView addSubview:self.previewLabel];
//        }
        
        
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
