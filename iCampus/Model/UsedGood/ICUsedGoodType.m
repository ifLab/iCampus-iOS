//
//  ICUsedGoodType.m
//  iCampus
//
//  Created by EricLee on 14-6-2.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodType.h"

@implementation ICUsedGoodType

+ (NSArray*)typeList{
    NSString *urlString = @"http://m.bistu.edu.cn/newapi/secondhandtype.php";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    if (data) {
    
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *a in json) {
            ICUsedGoodType *type = [[ICUsedGoodType alloc] init];
            type.ID = a[@"id"];
            type.name = a[@"name"];
            [array addObject:type];
        }
        return [NSArray arrayWithArray:array];
    }else{
        return Nil;
    }
}


@end

