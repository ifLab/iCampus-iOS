//
//  ICUsedGoodUploadImageView.h
//  iCampus
//
//  Created by EricLee on 14-6-4.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICUsedGoodUploadImageView;

@protocol ICUsedGoodUploadImageViewDelegate <NSObject>

- (void)uploadImageView:(ICUsedGoodUploadImageView *)uploadImageView
            didUploaded:(BOOL)success;

- (void)uploadImageViewDidPressDeleteButton:(ICUsedGoodUploadImageView *)uploadImageView;

@end

@interface ICUsedGoodUploadImageView : UIImageView

@property (nonatomic, weak) id<ICUsedGoodUploadImageViewDelegate> delegate;
@property (nonatomic, copy) NSURL *URL;

- (void)upload;

@end
