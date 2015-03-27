//
//  ICNewsDetail.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-6.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICNewsDetail.h"
#import "ICNews.h"
#import "ICNewsDetailAttachment.h"
#include "../ICModelConfig.h"

@interface ICNewsDetail ()

@property (nonatomic, strong) NSArray *images;

@end

@implementation ICNewsDetail

+ (ICNewsDetail *)newsDetailWithNews:(ICNews *)news {
    return [[self alloc] initWithNews:news];
}

- (id)initWithNews:(ICNews *)news {
    self = [super init];
    if (self) {
        if (!news) {
            return self;
        }
        // get data
        NSString *urlString = [NSString stringWithFormat:@"%@/api/api.php?table=news&url=%@", ICNewsAPIURLPrefix, news.detailKey];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_NEWS_DETAIL_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICNewsDetailTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_NEWS_DETAIL_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICNewsDetailTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return nil;
        }
        NSString *dataString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if ([dataString isEqualToString:@"-1"] || [dataString isEqualToString:@"false"] || ([dataString characterAtIndex:0] != '{' && [dataString characterAtIndex:0] != '[')) {
#           ifdef IC_NEWS_DETAIL_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICNewsDetailTag, ICFailedTag, ICBrokenTag, urlString);
#           endif
            return nil;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_NEWS_DETAIL_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICNewsDetailTag, ICSucceededTag, urlString);
#       endif
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:kNilOptions
                                                               error:nil];
        NSArray *a = json[@"as"][@"a"];
        NSMutableArray *imageURLs = [NSMutableArray array];
        for (NSDictionary __strong *b in a) {
            if (![b.class isSubclassOfClass:NSDictionary.class]) {
                continue;
            }
            b = b[@"attributes"];
            NSURL *url = [NSURL URLWithString:b[@"url"]];
            [imageURLs addObject:url];
        }
        self.imageURLs = [NSArray arrayWithArray:imageURLs];
        json = json[@"property"];
        // source index
        self.sourceIndex = [json[@"docid"] intValue];
        // channel index
        self.channelIndex = [json[@"docchannel"] intValue];
        // type
        self.type = [json[@"doctype"] intValue];
        // title
        self.title = json[@"doctitle"];
        self.title = [self.title stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
        self.title = [self.title stringByReplacingOccurrencesOfString:@"\u3000\u3000" withString:@" "];
        // subtitles
        NSMutableArray *subtitles = [NSMutableArray array];
        NSString *subtitle;
        if ([[json[@"subdoctitle"] class] isSubclassOfClass:NSString.class]) {
            subtitle = json[@"subdoctitle"];
            [subtitles addObject:subtitle];
        } else {
            NSDictionary *subtitlesDictionary = json[@"subdoctitle"];
            for (subtitle in subtitlesDictionary) {
                [subtitles addObject:subtitle];
            }
        }
        // authors
        NSDictionary *authorsDictionary = json[@"docauthor"];
        NSMutableArray *authors = [NSMutableArray array];
        for (NSString *author in authorsDictionary) {
            [authors addObject:author];
        }
        self.authors = [NSArray arrayWithArray:authors];
        // source names
        NSDictionary *sourceNamesDictionary = json[@"docsourcename"];
        NSMutableArray *sourceNames = [NSMutableArray array];
        for (NSString *sourceName in sourceNamesDictionary) {
            [sourceNames addObject:sourceName];
        }
        self.sourceNames = [NSArray arrayWithArray:sourceNames];
        // source creation time
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:(NSString *)ICTimeZoneName]];
        NSString *sourceCreationTimeString = json[@"docreltime"];
        self.sourceCreationTime = [dateFormatter dateFromString:sourceCreationTimeString];
        // modification time
        NSString *modificationTimeString = json[@"opertime"];
        self.modificationTime = [dateFormatter dateFromString:modificationTimeString];
        // creator
        self.creator = json[@"cruser"];
        NSString *creationTimeString = json[@"crtime"];
        self.creationTime = [dateFormatter dateFromString:creationTimeString];
        // abstract
        self.abstract = json[@"docabstract"];
        // body
        self.body = json[@"dochtmlcon"];
        self.body = [self.body stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        self.body = [self.body stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        self.body = [self.body stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        self.body = [self.body stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        self.body = [self.body stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        // pc url
        self.pcURL = [NSURL URLWithString:json[@"pcurl"]];
    }
    return self;
}

@end
