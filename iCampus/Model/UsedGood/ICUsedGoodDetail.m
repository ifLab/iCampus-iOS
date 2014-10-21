//
//  ICUsedGoodDetail.m
//  iCampus
//
//  Created by EricLee on 14-4-8.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICUsedGoodDetail.h"
@implementation ICUsedGoodDetail


+ (instancetype)UsedGoodDetailWithUsedGood:(ICUsedGood *)goods{
    ICUsedGoodDetail *goodDetail=[[self alloc]initWithUsedGood:goods];
    return goodDetail;
    
}

- (id)initWithUsedGood:(ICUsedGood *)good{
    self = [super init];
    if (self) {
        self.ID=good.ID;
        self.time=good.time;
        self.title=good.title;
        self.price=good.price;
        self.author=good.author;
        self.preview=good.preview;
        self.introduction=good.introduction;
        self.imageURLs=good.imageURLs;
        self.Phone=good.Phone;
        self.Email=good.Email;
        self.QQ=good.QQ;
    }
    return self;

}


@end
