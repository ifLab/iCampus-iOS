//
//  ICLoginViewController.m
//  iCampus
//
//  Created by Darren Liu on 14-4-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICLoginViewController.h"
#import "ICLoginView.hh"
#import "MBProgressHUD.h"
#import "ICUser.h"

@interface ICLoginViewController () <ICLoginViewDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;

- (IBAction)dismiss:(id)sender;

@end

@implementation ICLoginViewController

- (void)viewDidLoad {
    self.HUD = [MBProgressHUD showHUDAddedTo:self.loginView
                                    animated:YES];
    [self.loginView loadWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/authorize", ICAuthAPIURLPrefix]]
                    redirectURI:@"about:blank"
                       clientID:@"3ef19cbbc8ff1bd9cecb1f646759a7a1"
                   clientSecret:@"294a5816a059d9bb588bf3221010bfac"];
};

- (void)loginView:(ICLoginView *)loginView
             user:(ICUser *)user
         didLogin:(BOOL)success {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate loginViewController:self
                                      user:user
                                  didLogin:success];
    }];
    
    // 注册推送别名
    ICAppDelegate *delegate = (ICAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setAliasWith:user.ID];
    NSLog(@"[ICLoginViewController]已注册个推别名为：%@", user.ID);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(dismiss:)];
}

- (void)        loginView:(ICLoginView *)loginView
   didFinishLoadLoginPage:(BOOL)successfully {
    [self.HUD hide:YES];
}

- (IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:
     ^{
         if (self.delegate && [self.delegate conformsToProtocol:@protocol(ICLoginViewControllerDelegate)]) {
             if (self.navigationItem.rightBarButtonItem.style != UIBarButtonItemStyleDone) {
                 [self.delegate loginViewController:self
                                               user:nil
                                           didLogin:NO];
             }
         }
     }];
}

@end
