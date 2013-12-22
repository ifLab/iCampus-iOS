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
        NSString *urlString = [NSString stringWithFormat:@"http://%@/api/api.php?table=news&url=%@", ICNewsServerDomain, news.detailKey];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_NEWS_MODULE_DETAIL_DEBUG__)
            NSLog(@"%@ %@ %@", ICNewsDetailTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef __IC_NEWS_MODULE_DETAIL_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICNewsDetailTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return nil;
        }
        NSString *dataString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if ([dataString isEqualToString:@"-1"] || [dataString isEqualToString:@"false"] || ([dataString characterAtIndex:0] != '{' && [dataString characterAtIndex:0] != '[')) {
#           ifdef __IC_NEWS_MODULE_DETAIL_DEBUG__
                NSLog(@"%@ %@ %@ %@", ICNewsDetailTag, ICFailedTag, ICBrokenTag, urlString);
#           endif
            return nil;
        }
#       if !defined(__IC_ERROR_ONLY_DEBUG__) && defined(__IC_NEWS_MODULE_DETAIL_DEBUG__)
            NSLog(@"%@ %@ %@", ICNewsDetailTag, ICSucceededTag, urlString);
#       endif
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:kNilOptions
                                                               error:nil];
        NSArray *a = [[json objectForKey:@"as"] objectForKey:@"a"];
        NSMutableArray *imageURLs = [NSMutableArray array];
        for (NSDictionary __strong *b in a) {
            if (![b.class isSubclassOfClass:NSDictionary.class]) {
                continue;
            }
            b = [b objectForKey:@"attributes"];
            NSURL *url = [NSURL URLWithString:[b objectForKey:@"url"]];
            [imageURLs addObject:url];
        }
        self.imageURLs = [NSArray arrayWithArray:imageURLs];
        json = [json objectForKey:@"property"];
        // source index
        self.sourceIndex = [[json objectForKey:@"docid"] intValue];
        // channel index
        self.channelIndex = [[json objectForKey:@"docchannel"] intValue];
        // type
        self.type = [[json objectForKey:@"doctype"] intValue];
        // title
        self.title = [json objectForKey:@"doctitle"];
        self.title = [self.title stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
        self.title = [self.title stringByReplacingOccurrencesOfString:@"\u3000\u3000" withString:@" "];
        // subtitles
        NSMutableArray *subtitles = [NSMutableArray array];
        NSString *subtitle;
        if ([[[json objectForKey:@"subdoctitle"] class] isSubclassOfClass:NSString.class]) {
            subtitle = [json objectForKey:@"subdoctitle"];
            [subtitles addObject:subtitle];
        } else {
            NSDictionary *subtitlesDictionary = [json objectForKey:@"subdoctitle"];
            for (subtitle in subtitlesDictionary) {
                [subtitles addObject:subtitle];
            }
        }
        // authors
        NSDictionary *authorsDictionary = [json objectForKey:@"docauthor"];
        NSMutableArray *authors = [NSMutableArray array];
        for (NSString *author in authorsDictionary) {
            [authors addObject:author];
        }
        self.authors = [NSArray arrayWithArray:authors];
        // source names
        NSDictionary *sourceNamesDictionary = [json objectForKey:@"docsourcename"];
        NSMutableArray *sourceNames = [NSMutableArray array];
        for (NSString *sourceName in sourceNamesDictionary) {
            [sourceNames addObject:sourceName];
        }
        self.sourceNames = [NSArray arrayWithArray:sourceNames];
        // source creation time
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:(NSString *)ICTimeZoneName]];
        NSString *sourceCreationTimeString = [json objectForKey:@"docreltime"];
        self.sourceCreationTime = [dateFormatter dateFromString:sourceCreationTimeString];
        // modification time
        NSString *modificationTimeString = [json objectForKey:@"opertime"];
        self.modificationTime = [dateFormatter dateFromString:modificationTimeString];
        // creator
        self.creator = [json objectForKey:@"cruser"];
        NSString *creationTimeString = [json objectForKey:@"crtime"];
        self.creationTime = [dateFormatter dateFromString:creationTimeString];
        // abstract
        self.abstract = [json objectForKey:@"docabstract"];
        // body
        self.body = [json objectForKey:@"dochtmlcon"];
        self.body = [self.body stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        self.body = [self.body stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        self.body = [self.body stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        self.body = [self.body stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        self.body = [self.body stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        // pc url
        self.pcURL = [NSURL URLWithString:[json objectForKey:@"pcurl"]];
    }
    return self;
}

@end
