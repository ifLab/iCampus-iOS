//
//  ICNewsChannelCell.m
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICNewsChannelCell.h"
#import "../../Model/News/ICNews.h"

@implementation ICNewsChannelCell

- (id)initWithChannel:(ICNewsChannel *)channel
      reuseIdentifier:(NSString *)reuseIdentifier
              isFirst:(BOOL)first {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.text = channel.title;
        if (first) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 1.0)];
            line.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
            [self.contentView addSubview:line];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *textLabel = self.textLabel       ; {
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font          = [UIFont systemFontOfSize:16.0];
        }
    }
    return self;
}

@end
