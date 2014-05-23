//
//  ICJob.m
//  iCampus
//
//  Created by Jerry Black on 14-3-30.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJob.h"

@interface ICJob ()

@property NSURL *url;
@property (strong, nonatomic) ICJobClassificationList *jobClassificationList;

@end

@implementation ICJob

+ (id)loadJobDetailWith:(NSInteger)jobID {
    ICJob *job = [[ICJob alloc] init];
    
    NSString *u = [NSString stringWithFormat:@"http://m.bistu.edu.cn/newapi/jobdetail.php?id="];
    u = [NSString stringWithFormat:@"%@%ld", u, (long)jobID];
    job.url = [NSURL URLWithString:u];
    NSLog(@"兼职：开始获取工作详情，%@", job.url);
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:job.url]
                                         returningResponse:nil
                                                     error:nil];
    if (!data) {
        NSLog(@"兼职：获取工作详情错误");
        return nil;
    }
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:nil];
    NSDictionary *j = json[0];
    job.index = [j[@"id"] intValue];
    job.title = j[@"title"];
//    job.type = (j[@"mod"] == 2 ? YES : NO)
    job.description = j[@"description"];
    job.location = j[@"location"];
    job.qualifications = j[@"qualifications"];
    job.salary = j[@"salary"];
    job.company = j[@"company"];
    job.contactName = j[@"contactName"];
    job.contactEmail = j[@"contactEmail"];
    job.contactPhone = j[@"contactPhone"];
    job.contactQQ = j[@"contactQQ"];
    job.promulgatorID = j[@"userid"];
    NSLog(@"兼职：获取工作详情成功");
    
//    // 获取并设置分类
//    job.jobClassificationList = [ICJobClassificationList loadJobClassificationList];
//    NSLog(@"分类列表数据获取成功");
//    for (ICJobClassification *jobClassification in job.jobClassificationList.jobClassificationList) {
//        if (jobClassification.index == [j[@"typeid"] intValue]) {
//            job.jobClassification = jobClassification;
//        }
//    }
    
    return job;
}

@end
