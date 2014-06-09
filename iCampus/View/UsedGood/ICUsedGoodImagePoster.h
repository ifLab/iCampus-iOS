//
//  ICUsedGoodImagePoster.h
//  iCampus
//
//  Created by EricLee on 14-6-4.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ICUsedGoodPublishViewDelegate <UIScrollViewDelegate>

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion;

- (void)dismissViewControllerAnimated:(BOOL)flag
                           completion:(void (^)(void))completion;

@end

@interface ICUsedGoodImagePoster : UIScrollView

@property (nonatomic, weak) id<ICUsedGoodPublishViewDelegate> delegate;
- (NSString *)imageURLString;

@end
