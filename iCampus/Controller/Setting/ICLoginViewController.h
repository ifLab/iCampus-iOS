//
//  ICLoginViewController.h
//  iCampus
//
//  Created by Darren Liu on 14-4-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICLoginView.hh"

@class ICLoginViewController;
@class ICUser;

@protocol ICLoginViewControllerDelegate <NSObject>

- (void)loginViewController:(ICLoginViewController *)loginViewContrller
                       user:(ICUser *)user
                   didLogin:(BOOL)success;

@end

@interface ICLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet ICLoginView *loginView;
@property (weak, nonatomic) id <ICLoginViewControllerDelegate> delegate;

@end
