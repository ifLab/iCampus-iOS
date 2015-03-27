//
//  KMClassTableModel.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-8-24.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMClassTableModel.h"
#import "ICUser.h"

@implementation KMCourseObject

@end

@interface KMClassTableModel ()

@property (strong, nonatomic, readwrite) NSMutableArray *weeklyCourses;

@property (strong, nonatomic, readwrite) NSMutableArray *availableColors;

@end

@implementation KMClassTableModel

- (NSArray *)availableColors
{
    if (!_availableColors) {
        _availableColors = [@[[UIColor colorWithRed:232/255.0 green:208/255.0 blue:169/255.0 alpha:1.0],
                              [UIColor colorWithRed:143/255.0 green:188/255.0 blue:219/255.0 alpha:1.0],
                              [UIColor colorWithRed:255/255.0 green:174/255.0 blue:174/255.0 alpha:1.0],
                              [UIColor colorWithRed:176/255.0 green:229/255.0 blue:124/255.0 alpha:1.0],
                              [UIColor colorWithRed:86/255.0 green:186/255.0 blue:236/255.0 alpha:1.0],
                              [UIColor colorWithRed:156/255.0 green:183/255.0 blue:116/255.0 alpha:1.0],
                              [UIColor colorWithRed:255/255.0 green:153/255.0 blue:0 alpha:1.0],
                              [UIColor colorWithRed:51/255.0 green:103/255.0 blue:153/255.0 alpha:1.0],
                              [UIColor colorWithRed:255/255.0 green:114/255.0 blue:96/255.0 alpha:1.0],
                              [UIColor colorWithRed:185/255.0 green:106/255.0 blue:154/255.0 alpha:1.0],
                              ] mutableCopy];
    }
    return _availableColors;
}

- (NSMutableArray *)weeklyCourses
{
    if (!_weeklyCourses) {
        _weeklyCourses = [@[] mutableCopy];
    }
    return _weeklyCourses;
}

- (void)fetchWeeklyCoursesWithDate:(NSString *)date
{
    // used where the same course having the same color
    //NSMutableDictionary *colorSelected = [@{} mutableCopy];
    
    NSString *strURL = nil;
    if (date != nil) {
        strURL = [NSString stringWithFormat:@"%@/course.php?xh=%@&date=%@", ICClassTableAPIURLPrefix, ICCurrentUser.ID, date];
    } else {
        strURL = [NSString stringWithFormat:@"%@/course.php?xh=%@", ICClassTableAPIURLPrefix, ICCurrentUser.ID];
    }
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:4];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data == nil && connectionError != nil) {
                                   [_delegate KMClassTableDidFailLoadingCoursesData:nil];
                               } else {
                                   NSError *jsonError = nil;
                                   NSArray *list = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:NSJSONReadingAllowFragments
                                                                                     error:&jsonError];
                                   
                                   if (jsonError != nil) {
                                       [_delegate KMClassTableDidFailLoadingCoursesData:nil];
                                   } else {
                                       
                                       for (NSDictionary *item in list) {
                                           NSArray *courses = [item objectForKey:@"kc"];
                                           for (NSDictionary *c in courses) {
                                               KMCourseObject *course = [[KMCourseObject alloc] init];
                                               
                                               NSString *identifier = [c valueForKey:@"xkkh"];
                                               course.identifier = [identifier isEqual:[NSNull null]] ? @"-" : identifier;
                                               
                                               NSString *week = [c valueForKey:@"xqj"];
                                               course.week = [week isEqual:[NSNull null]] ? @"-" : week;
                                               
                                               NSString *orderInDay = [c valueForKey:@"djj"];
                                               course.orderInDay = [orderInDay isEqual:[NSNull null]] ? @"-" : orderInDay;
                                               
                                               NSString *lengthInLesson = [c valueForKey:@"skcd"];
                                               course.lengthInLesson = [lengthInLesson isEqual:[NSNull null]] ? @"1" :lengthInLesson;
                                               
                                               NSDictionary *detail = [c objectForKey:@"kcdm"];
                                               if ([detail isEqual:[NSNull null]]) {
                                                   NSString *allStr = [c valueForKey:@"kcb"];
                                                   if ([allStr isEqual:[NSNull null]]) {
                                                       course.courseName = @"-";
                                                       course.creditPoint = @"-";
                                                       course.studyHours = @"-";
                                                   } else {
                                                       course.courseName = allStr;
                                                       course.creditPoint = @"-";
                                                       course.studyHours = @"-";
                                                   }
                                               } else {
                                                   NSString *courseName = [detail valueForKey:@"kczwmc"];
                                                   course.courseName = [courseName isEqual:[NSNull null]] ? @"-" : courseName;
                                                   
                                                   NSString *creditPoint = [detail valueForKey:@"xf"];
                                                   course.creditPoint = [creditPoint isEqual:[NSNull null]] ? @"-" : creditPoint;
                                                   
                                                   NSString *studyHours = [detail valueForKey:@"zhxs"];
                                                   course.studyHours = [studyHours isEqual:[NSNull null]] ? @"-" :studyHours;
                                               }
                                               
                                               NSDictionary *teacher = [c objectForKey:@"jsxx"];
                                               if ([teacher isEqual:[NSNull null]]) {
                                                   course.teacherName = @"-";
                                               } else {
                                                   NSString *teacherName = [teacher valueForKey:@"xm"];
                                                   course.teacherName = [teacherName isEqual:[NSNull null]] ? @"-" : teacherName;
                                               }
                                               
                                               // background color start
                                               /*
                                               if ([colorSelected objectForKey:course.identifier]) {
                                                   course.backgroundColor = [colorSelected objectForKey:course.identifier];
                                               } else {
                                                   NSUInteger randomIndex = arc4random() % [self.availableColors count];
                                                   UIColor *color = [self.availableColors objectAtIndex:randomIndex];
                                                   if (color == nil) {
                                                       color = [UIColor colorWithRed:232/255.0 green:208/255.0 blue:169/255.0 alpha:1.0];
                                                   }
                                                   course.backgroundColor = color;
                                                   
                                                   [colorSelected setObject:color forKey:course.identifier];
                                                   [self.availableColors removeObject:color];
                                               }
                                               */
                                               course.backgroundColor = [UIColor colorWithRed:105/255.0 green:175/255.0 blue:75/255.0 alpha:1.0];
                                               
                                               // background color end
                                               
                                               // handle time string start
                                               NSInteger weekCount = course.week.integerValue;
                                               NSString *weekStr = nil;
                                               switch (weekCount) {
                                                   case 1:
                                                       weekStr = @"一";
                                                       break;
                                                   case 2:
                                                       weekStr = @"二";
                                                       break;
                                                   case 3:
                                                       weekStr = @"三";
                                                       break;
                                                   case 4:
                                                       weekStr = @"四";
                                                       break;
                                                   case 5:
                                                       weekStr = @"五";
                                                       break;
                                                   case 6:
                                                       weekStr = @"六";
                                                       break;
                                                   case 7:
                                                       weekStr = @"日";
                                                       break;
                                                       
                                                   default:
                                                       break;
                                               }
                                               NSMutableString *timeStr = [NSMutableString stringWithFormat:@"星期%@ 第", weekStr];
                                               int startCount = (int)(course.orderInDay.integerValue - 1);
                                               int count = (int)(course.lengthInLesson.integerValue + startCount);
                                               for (int i = startCount; i < count; i++) {
                                                   if (i == startCount) {
                                                       [timeStr appendString:[NSString stringWithFormat:@"%d", i + 1]];
                                                   } else {
                                                       [timeStr appendString:[NSString stringWithFormat:@",%d", i + 1]];
                                                   }
                                               }
                                               [timeStr appendString:@"节"];
                                               course.timeInStr = timeStr;
                                               
                                               // handle time string end
                                               
                                               [self.weeklyCourses addObject:course];
                                           }
                                       }
                                       [_delegate KMClassTableDidFinishLoadingCoursesData:_weeklyCourses];
                                   }
                               }
                           }
     ];
}

@end
