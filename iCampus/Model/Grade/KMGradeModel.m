//
//  KMGradeModel.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-8-23.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMGradeModel.h"
#import "KMNetworkActivityCenter.h"
#import "ICUser.h"

@implementation KMGradeObject

- (id)initWithName:(NSString *)aName
             point:(NSString *)aPoint
      usuallyGrade:(NSString *)aUsually
 experimentalGrade:(NSString *)aExperimental
         pageGrade:(NSString *)aPage
        finalGrade:(NSString *)aFinal
{
    self = [super init];
    if (self) {
        _name = aName;
        _point = aPoint;
        _usually = aUsually;
        _experimental = aExperimental;
        _pageGrade = aPage;
        _finalGrade = aFinal;
    }
    return self;
}

@end


@interface KMGradeModel ()

@property (strong, nonatomic) NSMutableArray *iYears;
@property (strong, nonatomic) NSMutableArray *iSemesters;
@property (strong, nonatomic) NSMutableArray *iCategories;

@property (strong, nonatomic) NSMutableArray *iGrades;

@end

@implementation KMGradeModel

- (KMGradeModel *)initWithIDNumber:(NSString *)number token:(NSString *)token
{
    self = [super init];
    if (self) {
        //..
    }
    return self;
}

- (NSArray *)years
{
    if (!_iYears || _iYears.count == 0) {
        
        _iYears = [@[] mutableCopy];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/year.php?xh=%@", ICGradeAPIURLPrefix, ICCurrentUser.ID]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                             timeoutInterval:10];
        [[KMNetworkActivityCenter sharedCenter] addNetworkingAction];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   [[KMNetworkActivityCenter sharedCenter] removeNetworkingAction];
                                   if (data) {
                                       NSError *parseErr = nil;
                                       NSArray *buildings = [NSJSONSerialization JSONObjectWithData:data
                                                                                            options:NSJSONReadingAllowFragments
                                                                                              error:&parseErr];
                                       
                                       if (buildings != nil || parseErr == nil) {
                                           // simplification
                                           for (NSDictionary *item in buildings) {
                                               // selection
                                               NSString *title = [item objectForKey:@"title"];
                                               [_iYears addObject:title];
                                               
                                           }
                                           
                                           [_iYears insertObject:@"不限" atIndex:0];
                                           
                                           [_delegate KMGradeModelDidFinishFethingWithPart:KMGradeModelPartYear];
                                       } else {
                                           
                                           [_delegate KMGradeModelDidFailFetchingWithPart:KMGradeModelPartYear];
                                       }
                                       
                                   } else {
                                       
                                       [_delegate KMGradeModelDidFailFetchingWithPart:KMGradeModelPartYear];
                                   }
                               }
         ];
    }
    return [_iYears copy];
}

- (NSArray *)semesters
{
    if (!_iSemesters || _iSemesters.count == 0) {
        _iSemesters = [@[@"不限", @"1", @"2"] mutableCopy];
    }
    return [_iSemesters copy];
}

- (NSArray *)categories
{
    if (!_iCategories || _iCategories.count == 0) {
        
        _iCategories = [@[] mutableCopy];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/courseclass.php", ICGradeAPIURLPrefix]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                             timeoutInterval:10];
        [[KMNetworkActivityCenter sharedCenter] addNetworkingAction];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   [[KMNetworkActivityCenter sharedCenter] removeNetworkingAction];
                                   if (data) {
                                       NSError *parseErr = nil;
                                       NSArray *buildings = [NSJSONSerialization JSONObjectWithData:data
                                                                                            options:NSJSONReadingAllowFragments
                                                                                              error:&parseErr];
                                       
                                       if (buildings != nil || parseErr == nil) {
                                           // simplification
                                           for (NSDictionary *item in buildings) {
                                               // selection
                                               NSString *title = [item objectForKey:@"title"];
                                               [_iCategories addObject:title];
                                               
                                           }
                                           
                                           [_iCategories insertObject:@"不限" atIndex:0];
                                           
                                           [_delegate KMGradeModelDidFinishFethingWithPart:KMGradeModelPartCategory];
                                       } else {
                                           
                                           [_delegate KMGradeModelDidFailFetchingWithPart:KMGradeModelPartCategory];
                                       }
                                       
                                   } else {
                                       
                                       [_delegate KMGradeModelDidFailFetchingWithPart:KMGradeModelPartCategory];
                                   }
                               }
         ];
    }
    return [_iCategories copy];
}

- (NSMutableArray *)grades
{
    if (!_grades) {
        _grades = [@[] mutableCopy];
    }
    return _grades;
}

- (void)gradesWithYear:(NSString *)year semester:(NSString *)semester category:(NSString *)category
{
    _iGrades = [@[] mutableCopy];
    
    /*
    NSString *strURL = [[NSString stringWithFormat:@"jwcapi.iflab.org/score.php?xh=%@&xn=%@&xq=%@&kcxz=%@",@"2011011064" , year, semester, category] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    */
    NSMutableString *strURL = [[NSString stringWithFormat:@"%@/score.php?xh=%@", ICGradeAPIURLPrefix, ICCurrentUser.ID] mutableCopy];
    if (![year isEqualToString:@"不限"]) {
        [strURL appendFormat:@"&xn=%@", year];
    }
    if (![semester isEqualToString:@"不限"]) {
        [strURL appendFormat:@"&xq=%@", semester];
    }
    if (![category isEqualToString:@"不限"]) {
        [strURL appendFormat:@"&kcxz=%@", category];
    }
    
    NSString *legalStrURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:legalStrURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:30];
    [[KMNetworkActivityCenter sharedCenter] addNetworkingAction];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               [[KMNetworkActivityCenter sharedCenter] removeNetworkingAction];
                               if (data) {
                                   NSError *parseErr = nil;
                                   NSArray *buildings = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&parseErr];
                                   
                                   if ([buildings isEqual:[NSNull null]]) {
                                       
                                       [_resultDelegate KMGradeResultDidFailFetchingData];
                                       
                                   } else {
                                       if (buildings != nil || parseErr == nil) {
                                           // simplification
                                           for (NSDictionary *item in buildings) {
                                               // selection
                                               NSString *name = [item objectForKey:@"kcmc"];
                                               NSString *point = [item objectForKey:@"xf"];
                                               NSString *usually = [item objectForKey:@"pscj"];
                                               NSString *pageGrade = [item objectForKey:@"qmcj"];
                                               NSString *experimental = [item objectForKey:@"sycj"];
                                               NSString *grade = [item objectForKey:@"cj"];
                                               
                                               KMGradeObject *obj = [[KMGradeObject alloc] initWithName:name
                                                                                                  point:point
                                                                                           usuallyGrade:usually
                                                                                      experimentalGrade:experimental
                                                                                              pageGrade:pageGrade
                                                                                             finalGrade:grade];
                                               
                                               [_iGrades addObject:obj];
                                           }
                                           
                                           self.grades = _iGrades;
                                           [_resultDelegate KMGradeResultDidFinsihFetchingData];
                                       } else {
                                           
                                           [_resultDelegate KMGradeResultDidFailFetchingData];
                                       }
                                   }
                                   
                               } else {
                                   
                                   [_resultDelegate KMGradeResultDidFailFetchingData];
                               }
                           }
     ];
}

@end
