//
//  YZLostDetailsViewController.h
//  iCampus
//
//  Created by 戚译中 on 2017/9/30.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^ReturnBlock)(void);

@interface YZLostDetailsViewController : UIViewController

@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic ,strong) UIButton* PhoneBtn;
@property (nonatomic ,strong) UIButton* ChatBtn;

@end
