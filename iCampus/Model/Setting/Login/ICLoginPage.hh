//
//  ;
//  iCampus
//
//  Created by Darren Liu on 14-4-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICLoginPage;

@protocol ICLoginPageDelegate

- (void) loginPage:(ICLoginPage *)loginPage
     didFinishLoad:(BOOL)success;

@end

@interface ICLoginPage : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, weak) id<ICLoginPageDelegate> delegate;

- (void) loadWithURL:(NSURL *)URL
         redirectURI:(NSString *)redirectURI
            clientID:(NSString *)clientID
        clientSecret:(NSString *)clientSecret;

@end
