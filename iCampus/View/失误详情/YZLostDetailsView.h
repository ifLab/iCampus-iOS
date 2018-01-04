//
//  YZLostDetailsView.h
//  iCampus
//
//  Created by 戚译中 on 2017/9/30.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZLostDetailsViewDelegate <NSObject>

- (void) clickImage:(NSArray*)photos andTag:(NSInteger)tag;

@end

@interface YZLostDetailsView : UIView

@property (nonatomic ,strong) NSDictionary* dataSource;
@property (nonatomic ,strong) UIScrollView* scrollview;
@property (nonatomic ,strong) NSArray *imageArray;
@property (nonatomic ,weak) id<YZLostDetailsViewDelegate> LostDetailsViewDelegate;

- (UIImage *)shareImage;

@end

