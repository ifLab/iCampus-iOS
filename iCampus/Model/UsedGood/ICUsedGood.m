//
//  ICUsedGood.m
//  iCampus
//
//  Created by EricLee on 14-4-8.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGood.h"
#import "ICUsedGoodType.h"

@implementation ICUsedGood



+ (NSArray *)goodListWithType:(ICUsedGoodType *)type {
    
    NSMutableArray *list = [NSMutableArray array];
    NSString *URLString = @"http://m.bistu.edu.cn/newapi/secondhand.php";
    if (type) {
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"?typeid=%@", type.ID]];
    }
    NSURL *URL=[NSURL URLWithString:URLString];
    NSURLRequest *URLRequest=[NSURLRequest requestWithURL:URL];
    NSData *data=[NSURLConnection sendSynchronousRequest:URLRequest returningResponse:nil error:nil];
    if (data) {
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
      

        for (NSDictionary *a in json) {
            ICUsedGood* good = [[ICUsedGood alloc] init];
            good.description=a[@"description"];
            good.ID=a[@"id"];
            NSString *urlString=a[@"pic"];
            NSMutableArray *imgURLlist=[NSMutableArray array];
            for (NSString __strong *str in [urlString componentsSeparatedByString:@";"]) {
                NSURL *url=[NSURL URLWithString:str];
                if (url) {
                    [imgURLlist addObject:url];
                }
            }
            good.imageURLs=[NSMutableArray arrayWithArray:imgURLlist];
            
            good.price=a[@"price"];
            good.title=a[@"titile"];
            good.time=a[@"time"];
            good.typeID=a[@"typeid"];
            good.position=a[@"xqdm"];
            good.Phone=a[@"mobile"];
            good.QQ=a[@"QQ"];
            good.Email=a[@"email"];
            [list addObject:good];
        }
        NSArray *reveredArray = [[list reverseObjectEnumerator]allObjects];
        return [NSArray arrayWithArray:reveredArray];
    }
    return nil;
}
+ (NSArray *)goodListWithUserID:(NSString *)userID {
    NSMutableArray *list = [NSMutableArray array];
    NSString *URLString = @"http://m.bistu.edu.cn/newapi/secondhand.php";
    if (userID) {
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"?userid=%@", userID]];
    }
    NSURL *URL=[NSURL URLWithString:URLString];
    NSURLRequest *URLRequest=[NSURLRequest requestWithURL:URL];
    NSData *data=[NSURLConnection sendSynchronousRequest:URLRequest returningResponse:nil error:nil];
    if (data) {
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
      

        for (NSDictionary *a in json) {
            ICUsedGood* good = [[ICUsedGood alloc] init];
            good.description=a[@"description"];
            good.ID=a[@"id"];
            NSString*urlString=a[@"pic"];
            NSMutableArray *imgURLlist=[NSMutableArray array];
            for (NSString __strong *str in [urlString componentsSeparatedByString:@";"]) {
                NSURL *url=[NSURL URLWithString:str];
                if (url) {
                    [imgURLlist addObject:url];
                }

            }
            good.imageURLs=[NSMutableArray arrayWithArray:imgURLlist];
            good.time=a[@"time"];
            good.price=a[@"price"];
            good.title=a[@"titile"];
            good.typeID=a[@"typeid"];
            good.position=a[@"xqdm"];
            good.Phone=a[@"mobile"];
            good.QQ=a[@"QQ"];
            good.Email=a[@"email"];
            [list addObject:good];
                    }
        NSArray *reveredArray = [[list reverseObjectEnumerator]allObjects];
        return [NSArray arrayWithArray:reveredArray];
    }else{
        return Nil;
    }
}


@end
