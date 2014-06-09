//
//  ICUsedGoodPublishTableViewController.h
//  iCampus
//
//  Created by EricLee on 14-6-3.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICUsedGoodPublishTableViewController;
@protocol ICUsedGoodPublishTableViewControllerDelegate <NSObject>

- (void)publishViewController:(ICUsedGoodPublishTableViewController*)viewController
                   didPublish:(BOOL)success;


@end


@interface ICUsedGoodPublishTableViewController : UITableViewController <UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, weak) id<ICUsedGoodPublishTableViewControllerDelegate> delegate;

@end

