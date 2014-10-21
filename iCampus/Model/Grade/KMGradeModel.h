//
//  KMGradeModel.h
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-8-23.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMGradeObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *point;
@property (strong, nonatomic) NSString *usually;
@property (strong, nonatomic) NSString *experimental;
@property (strong, nonatomic) NSString *pageGrade;
@property (strong, nonatomic) NSString *finalGrade;

- (id)initWithName:(NSString *)aName
             point:(NSString *)aPoint
      usuallyGrade:(NSString *)aUsually
 experimentalGrade:(NSString *)aExperimental
         pageGrade:(NSString *)aPage
        finalGrade:(NSString *)aFinal;

@end

typedef enum : NSUInteger {
    KMGradeModelPartYear,
    KMGradeModelPartSemester,
    KMGradeModelPartCategory,
} KMGradeModelPart;

#define KMGradeModelSelectedKeyYear @"KMGradeModelSelectedKeyYear"
#define KMGradeModelSelectedKeySemester @"KMGradeModelSelectedKeySemester"
#define KMGradeModelSelectedKeyCategory @"KMGradeModelSelectedKeyCategory"

@protocol KMGradeModelDelegate <NSObject>

- (void)KMGradeModelDidFinishFethingWithPart:(KMGradeModelPart)part;
- (void)KMGradeModelDidFailFetchingWithPart:(KMGradeModelPart)part;

@end

@protocol KMGradeModelResultDelegate <NSObject>

- (void)KMGradeResultDidFinsihFetchingData;
- (void)KMGradeResultDidFailFetchingData;

@end

@interface KMGradeModel : NSObject

- (KMGradeModel *)initWithIDNumber:(NSString *)number token:(NSString *)token;

@property (weak, nonatomic) id<KMGradeModelDelegate> delegate;
@property (weak, nonatomic) id<KMGradeModelResultDelegate> resultDelegate;

- (NSArray *)years;
- (NSArray *)semesters;
- (NSArray *)categories;


@property (strong, nonatomic) NSMutableArray *grades;
- (void)gradesWithYear:(NSString *)year semester:(NSString *)semester category:(NSString *)category;

@end

