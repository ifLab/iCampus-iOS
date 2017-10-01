//
//  YZLostDetailsView.h
//  iCampus
//
//  Created by 戚译中 on 2017/9/30.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZLostDetailsView : UIView
@property (nonatomic, strong) NSDictionary* dataSource;
@property (nonatomic, strong) UIScrollView* scrollview;
@property (nonatomic ,strong) UILabel* TimeAndPhoneLabel;
@property (nonatomic ,strong) NSArray* imageArray;
@end
