//
//  ICYellowPage.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-11.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICYellowPage.h"
#import "ICYellowPageContact.h"
#import "../ICModelConfig.h"

@interface ICYellowPage ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICYellowPage

+ (ICYellowPage *)yellowPage {
    ICYellowPage *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=yellowpage&list=0", ICYellowPageServerDomain];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_YELLOWPAGE_MODULE_DEBUG__)
            NSLog(@"%@ %@ %@", ICYellowPageTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef __IC_YELLOWPAGE_MODULE_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICYellowPageTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return instance;
        }
        NSString *dataString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n"
                                                           withString:@""];
        if ([dataString characterAtIndex:0] != '[' && [dataString characterAtIndex:0] != '{') {
#           ifdef __IC_YELLOWPAGE_MODULE_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICYellowPageTag, ICFailedTag, ICBrokenTag, urlString);
#           endif
            return instance;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_YELLOWPAGE_MODULE_DEBUG__)
            NSLog(@"%@ %@ %@", ICYellowPageTag, ICSucceededTag, urlString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        for (NSDictionary *a in json) {
            ICYellowPageContact *contact = [[ICYellowPageContact alloc] init];
            contact.index = [[a objectForKey:@"id"] intValue];
            contact.name = [a objectForKey:@"name"];
            contact.name = [contact.name stringByReplacingOccurrencesOfString:@"\u3000" withString:@""];
            contact.name = [contact.name stringByReplacingOccurrencesOfString:@" "      withString:@""];
            contact.name = [contact.name stringByReplacingOccurrencesOfString:@"("      withString:@"\uff08"];
            contact.name = [contact.name stringByReplacingOccurrencesOfString:@")"      withString:@"\uff09"];
            contact.name = [contact.name stringByReplacingOccurrencesOfString:@":"      withString:@"\uff1a"];
            contact.telephone = [a objectForKey:@"telnum"];
            contact.departmentIndex = [[a objectForKey:@"depart"] intValue];
            [instance addContact:contact];
        }
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (void)addContact:(ICYellowPageContact *)contact {
    [self.array addObject:contact];
}

- (void)addContactFromYellowPage:(ICYellowPage *)yellowPage {
    [self.array addObjectsFromArray:yellowPage.array];
}

- (void)removeContact:(ICYellowPageContact *)contact {
    [self.array removeObject:contact];
}

- (NSUInteger)count {
    return [self.array count];
}

- (ICYellowPageContact *)firstContact {
    return self.array.firstObject;
}

- (ICYellowPageContact *)lastContact {
    return self.array.lastObject;
}

- (ICYellowPageContact *)contactAtIndex:(NSUInteger)index {
    return [self.array objectAtIndex:index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state
                                           objects:buffer
                                             count:len];
}

@end
