//
//  ICNewsChannelCell.h
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICNewsChannel;

@interface ICNewsChannelCell : UITableViewCell

- (id)initWithChannel:(ICNewsChannel *)channel
      reuseIdentifier:(NSString *)reuseIdentifier;

@end
