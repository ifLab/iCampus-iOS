//
//  ICLoginView.hh
//  iCampus
//
//  Created by Darren Liu on 14-4-23.
//  Copyright (c) 2014年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ICLoginUnknownToken = 0,
    ICLoginBearerToken  = 1,
    ICLoginMacToken     = 2
} ICLoginTokenType;

@class ICLoginView;
@class ICUser;

@protocol ICLoginViewDelegate <NSObject>

- (void) loginView:(ICLoginView *)loginView
              user:(ICUser *)user
          didLogin:(BOOL)success;

- (void)        loginView:(ICLoginView *)loginView
   didFinishLoadLoginPage:(BOOL)successfully;

@end

@interface ICLoginView : UIView

@property (nonatomic, weak) IBOutlet id<ICLoginViewDelegate> delegate;

- (void) loadWithURL:(NSURL *)URL
         redirectURI:(NSString *)redirectURI
            clientID:(NSString *)clientID
        clientSecret:(NSString *)clientSecret;

@end
