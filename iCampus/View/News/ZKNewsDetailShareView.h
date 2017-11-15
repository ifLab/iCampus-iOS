//
//  ZKNewsDetailShareView.h
//  iCampus
//
//  Created by 徐正科 on 2017/11/4.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKNewsDetailShareView : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bodyImage;


@property(weak,nonatomic)NSString *newsTitle;
@property(strong,nonatomic)UIImage *image;
@property(assign,nonatomic)CGSize imageSize;

@end
