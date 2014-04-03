//
//  ICAboutWebpage.h
//  iCampus
//
//  Created by Darren Liu on 14-4-3.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICAboutWebpage : NSObject

@property (nonatomic) NSUInteger index;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

+ (instancetype)introductionPage;

+ (instancetype)historyPage;

+ (instancetype)collegePage;

+ (instancetype)creditsPage;

+ (instancetype)ifLabPage;

+ (instancetype)pageWithCategory:(NSString *)category;

@end
