//
//  ICUsedGoodFilterViewController.h
//  iCampus
//
//  Created by EricLee on 14-4-10.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICUsedGoodFilterViewController,ICUsedGoodType;
@protocol ICUsedGoodFilterViewControllerDelegate <NSObject>

- (void) usedGoodFilterView:(ICUsedGoodFilterViewController *)view
               SelectedType:(ICUsedGoodType *)type;

@end

@interface ICUsedGoodFilterViewController : UITableViewController

@property (nonatomic,weak)id<ICUsedGoodFilterViewControllerDelegate> delegate;

@end
