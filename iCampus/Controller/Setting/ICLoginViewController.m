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
    [self.loginView loadWithURL:[NSURL URLWithString:@"https://222.249.250.89:8443/oauth/authorize"]
                    redirectURI:@"about:blank"
                       clientID:@"6cd01d6c9a0d60beae9e0dab22d9a7d4"
                   clientSecret:@"30f536f4cf00e5ba2d2354d341446b01"];
};

- (void)loginView:(ICLoginView *)loginView
             user:(ICUser *)user
         didLogin:(BOOL)success {
    [self.delegate loginViewController:self
                                  user:user
                              didLogin:success];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(dismiss:)];
}

- (void)        loginView:(ICLoginView *)loginView
   didFinishLoadLoginPage:(BOOL)successfully {
    [self.HUD hide:YES];
}

- (IBAction)dismiss:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ICLoginViewControllerDelegate)]) {
        if (self.navigationItem.rightBarButtonItem.style != UIBarButtonItemStyleDone) {
            [self.delegate loginViewController:self
                                          user:nil
                                      didLogin:NO];
        }
    }
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

@end
