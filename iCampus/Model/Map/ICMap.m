//
//  ICMap.m
//  iCampus
//
//  Created by Kwei Ma on 14-3-10.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICMap.h"

@interface ICMap ()

@property (strong, nonatomic) NSMutableArray *list;

@end

@implementation ICMap

- (id)init
{
    if (self = [super init]) {
        self.list = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)mapList
{
    [self loadDataFromServer];
    return self.list;
}

- (NSDictionary *)informationWithAreaID:(NSString *)idstring
{
    for (NSDictionary *dict in self.list) {
        NSString *idstr = [dict valueForKey:ICMapIDStr];
        if ([idstr isEqualToString:idstring]) {
            return dict;
        }
    }
    return nil;
}

- (void)loadDataFromServer
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/map.php", ICMapAPIURLPrefix]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:48];
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:&error];
    if (error) {
        return;
    }
    NSArray * origin= [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
    if (error) {
        return;
    }
    
    if ([origin isEqual:[NSNull null]]) {
        return;
    }
    
    for (NSDictionary *each in origin) {
        
        NSNumber *longitude = @([(NSString *)[each valueForKey:@"longitude"] floatValue]);
        NSNumber *latitute = @([(NSString *)[each valueForKey:@"latitude"] floatValue]);
        NSNumber *zoomLevel = @([(NSString *)[each valueForKey:@"zoom"] floatValue]);
        
        NSString *idstr = (NSString *)[each valueForKey:@"id"];
        NSString *name = (NSString *)[each valueForKey:@"areaName"];
        NSString *addr = (NSString *)[each valueForKey:@"areaAddress"];
        NSString *zip = (NSString *)[each valueForKey:@"zipCode"];
        
        NSDictionary *dict = @{ICMapLongitude: longitude,
                              ICMapLatitude: latitute,
                              ICMapZoomLevel: zoomLevel,
                              ICMapIDStr: idstr,
                              ICMapName: name,
                              ICMapAddress: addr,
                              ICMapZipCode: zip};
        [self.list addObject:dict];
    }
}

@end
