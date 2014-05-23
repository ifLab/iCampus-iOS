//
//  ICJob.h
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICJobClassification.h"
#import "ICJobClassificationList.h"

@interface ICJob : NSObject

@property(nonatomic) NSUInteger index;
@property(nonatomic,copy) NSString *title;          //工作名称
//@property BOOL type;                                //工作类型：兼职为1，全职为2
//@property ICJobClassification *jobClassification;   //工作分类
@property(nonatomic,copy) NSString *description;    //简述
@property(nonatomic,copy) NSString *location;       //工作地点
@property(nonatomic,copy) NSString *qualifications; //任职要求
@property(nonatomic,copy) NSString *salary;         //薪资待遇
@property(nonatomic,copy) NSString *contactName;    //联系方式
@property(nonatomic,copy) NSString *contactEmail;
@property(nonatomic,copy) NSString *contactPhone;
@property(nonatomic,copy) NSString *contactQQ;
@property(nonatomic,copy) NSString *company;
//@property(nonatomic,copy) NSString *companyAddress;
//@property(nonatomic,copy) NSString *companyIntroduction;
@property(nonatomic,copy) NSString *promulgatorID;

+ (id)loadJobDetailWith:(NSInteger)jobID;

@end
