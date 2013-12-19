//
//  ICNewsListViewCell.m
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsCell.h"
#import "../../External/UIKit+AFNetworking/UIImageView+AFNetworking.h"
#import "../../Model/News/ICNews.h"

@implementation ICNewsCell

- (id)initWithNews:(ICNews *)news
   reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.text   = news.title;
        self.previewLabel.text = news.preview;
        ICNewsCell __weak *__self = self;
        [self.thumbnailImageView setImageWithURLRequest:[NSURLRequest requestWithURL:news.imageURL]
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
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 66.7, 50.0)];
        self.thumbnailImageView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        self.thumbnailImageView.contentMode     = UIViewContentModeScaleAspectFill;
        self.thumbnailImageView.clipsToBounds   = YES;
        [self.contentView addSubview:self.thumbnailImageView];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.frame     = CGRectMake(86.0, 10.0, 224.0, 18.0);
        self.titleLabel.font      = [UIFont systemFontOfSize:16.0];
        self.titleLabel.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:self.titleLabel];
        self.previewLabel = [[UILabel alloc] initWithFrame:CGRectMake(86.0, 22.0, 224.0, 50.0)];
        self.previewLabel.font          = [UIFont systemFontOfSize:12.0];
        self.previewLabel.numberOfLines = 2;
        self.previewLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.previewLabel.textColor     = [UIColor grayColor];
        [self.contentView addSubview:self.previewLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 1.0)];
        line.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        [self.contentView addSubview:line];
    }
    return self;
}

@end
