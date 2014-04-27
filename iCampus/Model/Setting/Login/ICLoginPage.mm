//
//  ICLoginPage.mm
//  iCampus
//
//  Created by Darren Liu on 14-4-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICLoginPage.hh"
#import "AFNetworking.h"

@interface ICLoginPage ()

@end

@implementation ICLoginPage

- (void) loadWithURL:(NSURL *)URL
         redirectURI:(NSString *)redirectURI
            clientID:(NSString *)clientID
        clientSecret:(NSString *)clientSecret {
    redirectURI = [redirectURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    typeof(self) __weak __self = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URL.absoluteString
      parameters:@{@"redirect_uri" : redirectURI,
                   @"response_type": @"token",
                   @"client_id"    : clientID,
                   @"client_secret": clientSecret}
         success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         __self.content = [[NSString alloc] initWithData:responseObject
                                                encoding:NSUTF8StringEncoding];
         [__self.delegate loginPage:__self
                      didFinishLoad:YES];
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [__self.delegate loginPage:__self
                      didFinishLoad:NO];
     }];
}

@end
