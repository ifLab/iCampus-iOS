//
//  ICAboutWebpage.m
//  iCampus
//
//  Created by Darren Liu on 14-4-3.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICAboutWebpage.h"
#import "ICModelConfig.h"

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
    return [self pageWithCategory:@"intro"];
}

+ (instancetype)historyPage {
    return [self pageWithCategory:@"history"];
}

+ (instancetype)collegePage {
    return [self pageWithCategory:@"colleges"];
}

+ (instancetype)creditsPage {
    return [self pageWithCategory:@"credits"];
}

+ (instancetype)ifLabPage {
    return [self pageWithCategory:@"iflab"];
}

+ (instancetype)pageWithCategory:(NSString *)category {
    ICAboutWebpage *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/newapi/intro.php?mod=%@", ICAboutServerDomain, category];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_ABOUT_DATA_MODULE_DEBUG)
        NSLog(@"%@ %@ %@", ICAboutTag, ICFetchingTag, urlString);
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
#           ifdef IC_ABOUT_DATA_MODULE_DEBUG
            NSLog(@"%@ %@ %@ %@", ICAboutTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return instance;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_ABOUT_DATA_MODULE_DEBUG)
        NSLog(@"%@ %@ %@", ICAboutTag, ICSucceededTag, urlString);
#       endif
        instance.index = [json[@"id"] intValue];
        instance.title = json[@"introName"];
        instance.content = json[@"introCont"];
    }
    return instance;
}

@end
