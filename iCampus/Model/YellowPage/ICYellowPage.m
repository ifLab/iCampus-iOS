//
//  ICYellowPage.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-11.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <string.h>
#import "ICYellowPage.h"
#import "ICYellowPageContact.h"
#import "../ICModelConfig.h"
#import "ICYellowPageDepartment.h"

@interface ICYellowPage ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICYellowPage

+ (ICYellowPage *)yellowPageWithDepartment:(ICYellowPageDepartment *)department {
    ICYellowPage *instance = [[self alloc] init];
    if (instance) {
        NSString *urlString = [NSString stringWithFormat:@"%@/yellowpage.php?action=tel&catid=%lu", ICYellowPageAPIURLPrefix, (unsigned long)department.departmentIndex];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_YELLOWPAGE_CONTACT_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICYellowPageListTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_YELLOWPAGE_CONTACT_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICYellowPageListTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return instance;
        }
        NSString *dataString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n"
                                                           withString:@""];
        if ([dataString characterAtIndex:0] != '[' && [dataString characterAtIndex:0] != '{') {
#           ifdef IC_YELLOWPAGE_CONTACT_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICYellowPageListTag, ICFailedTag, ICBrokenTag, urlString);
#           endif
            return instance;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_YELLOWPAGE_CONTACT_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICYellowPageListTag, ICSucceededTag, urlString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        for (NSDictionary *a in json) {
            ICYellowPageContact *contact = [[ICYellowPageContact alloc] init];
            contact.index = [a[@"id"] intValue];
            contact.name = a[@"name"];
            contact.telephone = a[@"telnum"];
            contact.departmentIndex = [a[@"depart"] intValue];
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
    return (self.array)[index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state
                                           objects:buffer
                                             count:len];
}

- (ICYellowPage *)yellowPageSortedByPinyin {
    ICYellowPage *instance = [[ICYellowPage alloc] init];
    instance.array = [[self.array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ICYellowPageContact *contact1 = obj1;
        ICYellowPageContact *contact2 = obj2;
        NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        const char *name1 = [contact1.name cStringUsingEncoding:gbk];
        const char *name2 = [contact2.name cStringUsingEncoding:gbk];
        const int value = strcmp(name1, name2);
        NSComparisonResult result;
        if (value < 0) {
            result = NSOrderedAscending;
        } else if (value > 0) {
            result = NSOrderedDescending;
        } else {
            result = NSOrderedSame;
        }
        return result;
    }] mutableCopy];
    return instance;
}

@end
