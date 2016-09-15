//
//  ICAboutWebpage.m
//  iCampus
//
//  Created by Darren Liu on 14-4-3.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICAboutWebpage.h"
#import "ICModelConfig.h"
#import "ICNetworkManager.h"

@implementation ICAboutWebpage

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.content = @"";
    }
    return self;
}

+ (instancetype)introductionPage {
    return [self pageWithCategory:@"1"];
}

+ (instancetype)historyPage {
    return [self pageWithCategory:@"2"];
}

+ (instancetype)collegePage {
    return [self pageWithCategory:@"3"];
}

+ (instancetype)creditsPage {
    return [self pageWithCategory:@"4"];
}

+ (instancetype)ifLabPage {
    return [self pageWithCategory:@"47"];
}

+ (void)fetchPageWithSuccess:(void (^)(NSArray *))success
                     failure:(void (^)(NSError *))failure {
    [[ICNetworkManager defaultManager] GET:@"About"
                                parameters:nil
                                   success:^(NSDictionary *data) {
                                       NSMutableArray *instance = [NSMutableArray array];
                                       for (NSDictionary *aboutData in data[@"resource"]) {
                                           ICAboutWebpage *page = [[ICAboutWebpage alloc] init];
                                           page.index = [aboutData[@"id"] intValue];
                                           page.title = aboutData[@"aboutName"];
                                           page.content = aboutData[@"aboutDetails"];
                                           [instance addObject:page];
                                       }
                                       success(instance);
                                   } failure:^(NSError *error) {
                                       if (failure) {
                                           failure(error);
                                       }
                                   }];
}

+ (instancetype)pageWithCategory:(NSString *)category {
    ICAboutWebpage *instance = [[self alloc] init];
    if (instance) {
        NSString *website = [ICNetworkManager defaultManager].website;
        NSString *path = [ICNetworkManager defaultManager].path[@"About"];
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@", website, path, @"/?api_key=3528bd808dde403b83b456e986ce1632d513f7a06c19f5a582058be87be0d8c2"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_ABOUT_DATA_MODULE_DEBUG)
//        NSLog(@"%@ %@ %@", ICAboutTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
            return instance;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil][0];
        if (!json) {
//#           ifdef IC_ABOUT_DATA_MODULE_DEBUG
//            NSLog(@"%@ %@ %@ %@", ICAboutTag, ICFailedTag, ICNullTag, urlString);
//#           endif
            return instance;
        }
//#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_ABOUT_DATA_MODULE_DEBUG)
//        NSLog(@"%@ %@ %@", ICAboutTag, ICSucceededTag, urlString);
//#       endif
        for (NSDictionary *data in json[@"resource"]) {
            if (data[@"id"] == category) {
                instance.index = [data[@"id"] intValue];
                instance.title = data[@"aboutName"];
                instance.content = data[@"aboutDetails"];
            }
        }
    }
    return instance;
}

@end
