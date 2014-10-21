//
//  KMClassTableModel.h
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-8-24.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMCourseObject : NSObject

@property (strong, nonatomic) NSString *identifier; // 课程代码 xkkh
@property (strong, nonatomic) NSString *courseName; // 课程名 kcdm-kczwmc
@property (strong, nonatomic) NSString *creditPoint; // 学分
@property (strong, nonatomic) NSString *studyHours; // 总学时
@property (strong, nonatomic) NSString *teacherName; // 教师姓名

@property (strong, nonatomic) NSString *week; // 星期几
@property (strong, nonatomic) NSString *orderInDay; // 第几节课
@property (strong, nonatomic) NSString *lengthInLesson; // 共几节课
@property (strong, nonatomic) NSString *timeInStr;

@property (strong, nonatomic) UIColor *backgroundColor;

@end

@protocol KMClassTableModelDelegate <NSObject>

- (void)KMClassTableDidFinishLoadingCoursesData:(NSMutableArray *)courses;
- (void)KMClassTableDidFailLoadingCoursesData:(NSDictionary *)errorInfo;

@end

@interface KMClassTableModel : NSObject

@property (weak, nonatomic) id<KMClassTableModelDelegate> delegate;

@property (strong, nonatomic, readonly) NSMutableArray *availableColors;

@property (strong, nonatomic, readonly) NSMutableArray *weeklyCourses;
- (void)fetchWeeklyCoursesWithDate:(NSString *)date; // date can be nil

@end
