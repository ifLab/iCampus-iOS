//
//  ICLoginView.mm
//  iCampus
//
//  Created by Darren Liu on 14-4-23.
//  Copyright (c) 2014年 ifLab. All rights reserved.
//

#import "ICLoginView.hh"
#import "ICLoginPage.hh"
#import "ICUser.h"
#import "AFNetworking.h"
#include <iostream>
#include <string>

@interface ICLoginView () <UIWebViewDelegate, ICLoginPageDelegate>

@property (nonatomic, strong) UIWebView   *webView    ;
@property (nonatomic, strong) NSURL       *URL        ;
@property (nonatomic, copy)   NSString    *redirectURI;
@property (nonatomic, strong) ICLoginPage *loginPage  ;

@end

@implementation ICLoginView

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.loginPage = [[ICLoginPage alloc] init];
    self.loginPage.delegate = self;
    self.webView = [[UIWebView alloc] initWithFrame:self.frame];
    self.webView.delegate = self;
    [self addSubview:self.webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *wholeString = webView.request.URL.absoluteString.stringByRemovingPercentEncoding;
    bool redirect = false;
    std::string url = [wholeString cStringUsingEncoding:NSUTF8StringEncoding];
    std::string redirect_url = [self.redirectURI cStringUsingEncoding:NSUTF8StringEncoding];
    std::string fragment = "";
    int pos = 0;
    for (pos = 0; pos < url.length(); pos++) {
        if (url[pos] == '#') {
            if (url.substr(0, pos) == redirect_url) {
                redirect = true;
                fragment = url.substr(pos + 1);
            }
            break;
        }
    }
    if (redirect) {
        NSString *token = nil;
        ICLoginTokenType tokenType = ICLoginUnknownToken;
        NSUInteger expiresTime = 0;
        std::string s = fragment;
        unsigned int begin = 0;
        for (int i = 0; i < s.length(); i++) {
            if (s[i] == '#') {
                begin = i + 1;
            }
        }
        std::string current = "";
        for (int i = 0; i < s.length(); i++) {
            if (s[i] == '=') {
                current = s.substr(begin, i - begin);
                begin = i + 1;
            } else if (s[i] == '&') {
                std::string value = s.substr(begin, i - begin);
                if (current == "access_token") {
                    token = [NSString stringWithCString:value.c_str()
                                               encoding:NSUTF8StringEncoding];
                } else if (current == "token_type") {
                    if (value == "bearer") {
                        tokenType = ICLoginBearerToken;
                    } else if (value == "mac") {
                        tokenType = ICLoginMacToken;
                    }
                } else if (current == "expires_in") {
                    expiresTime = [NSString stringWithCString:value.c_str()
                                                     encoding:NSUTF8StringEncoding].integerValue;
                } else if (current == "scope") {
                    // useless now... won't reach
                }
                begin = i + 1;
            }
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ICUser *user = [[ICUser alloc] initWithToken:token
                                             expiresTime:expiresTime];
            BOOL loggedIn = [user login];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate loginView:self
                                    user:user
                                didLogin:loggedIn];
            });
        });
    }
}

- (void)loadWithURL:(NSURL *)URL
        redirectURI:(NSString *)redirectURI
           clientID:(NSString *)clientID
       clientSecret:(NSString *)clientSecret {
    self.URL = URL;
    self.redirectURI = redirectURI;
    [self.loginPage loadWithURL:URL
                    redirectURI:redirectURI
                       clientID:clientID
                   clientSecret:clientSecret];
}

- (void)loginPage:(ICLoginPage *)loginPage
    didFinishLoad:(BOOL)success {
    [self.webView loadHTMLString:loginPage.content
                         baseURL:self.URL];
    [self.delegate loginView:self
      didFinishLoadLoginPage:success];
}

@end
