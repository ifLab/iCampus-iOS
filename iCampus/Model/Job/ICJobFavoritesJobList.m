//
//  ICJobFavoritesJobList.m
//  iCampus
//
//  Created by Jerry Black on 14-5-28.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobFavoritesJobList.h"

@implementation ICJobFavoritesJobList

- (NSMutableArray *)favoritesList
{
    if (!_favoritesList) {
        _favoritesList = [@[] mutableCopy];
    }
    return _favoritesList;
}

+ (NSString *)getDataPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (![fm changeCurrentDirectoryPath:documentsDirectory]) {
        NSLog(@"兼职：进入Documents目录失败");
        return nil;
    }
    if (![fm changeCurrentDirectoryPath:@"ICJob"]) {
        if (![fm createDirectoryAtPath:@"ICJob"
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL]) {
            NSLog(@"兼职：创建ICJob目录失败");
            return nil;
        }
        if (![fm changeCurrentDirectoryPath:@"ICJob"]) {
            NSLog(@"兼职：进入ICJob目录失败");
            return nil;
        }
    }
    NSString *jobDirectory = [fm currentDirectoryPath];
    NSString *dataPath = [jobDirectory stringByAppendingPathComponent:@"FavoritesJobs.json"];
    NSLog(@"兼职：成功进入ICJob目录，%@", jobDirectory);
    if (![fm fileExistsAtPath:dataPath]) {
        if (![fm createFileAtPath:dataPath contents:nil attributes:nil]) {
            NSLog(@"兼职：创建FavoritesJobList失败");
            return nil;
        }
    }
    if (![fm isReadableFileAtPath:dataPath]) {
        NSLog(@"兼职：无法读取FavoritesJobList");
        return nil;
    }
    if (![fm isWritableFileAtPath:dataPath]) {
        NSLog(@"兼职：无法读取FavoritesJobList");
        return nil;
    }
    return dataPath;
}

+ (id)loadData {
    ICJob *job;
    ICJobFavoritesJobList *list = [[ICJobFavoritesJobList alloc] init];
    NSString *dataPath = [ICJobFavoritesJobList getDataPath];
    NSFileManager *fm = [[NSFileManager alloc] init];
    if (dataPath == nil) {
        return nil;
    }
    NSData *data = [fm contentsAtPath:dataPath];
    if (!data) {
        list.favoritesList = [[NSMutableArray alloc] init];
        return self;
    }
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:nil];
    for (NSDictionary *j in json) {
        job = [[ICJob alloc] init];
        job.index = [j[@"id"] intValue];
        job.title = j[@"title"];
        job.description = j[@"description"];
        job.location = j[@"location"];
        job.qualifications = j[@"qualifications"];
        job.salary = j[@"salary"];
        job.company = j[@"company"];
        job.contactName = j[@"contactName"];
        job.contactPhone = j[@"contactPhone"];
        job.contactEmail = j[@"contactEmail"];
        job.contactQQ = j[@"contactQQ"];
        job.promulgatorID = j[@"promulgatorID"];
        [list.favoritesList addObject:job];
    }
    return list;
}

- (BOOL)writeData {
    NSString *dataPath = [ICJobFavoritesJobList getDataPath];
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSMutableArray *jobArray = [NSMutableArray array];
    for (ICJob *job in self.favoritesList) {
        NSDictionary *j = [[NSDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"%lu", (unsigned long)job.index],
                                                                  job.title,
                                                                  job.description,
                                                                  job.location,
                                                                  job.qualifications,
                                                                  job.salary,
                                                                  job.company,
                                                                  job.contactName,
                                                                  job.contactPhone,
                                                                  job.contactEmail,
                                                                  job.contactQQ,
                                                                  job.promulgatorID]
                                                        forKeys:@[@"id",
                                                                  @"title",
                                                                  @"description",
                                                                  @"location",
                                                                  @"qualifications",
                                                                  @"salary",
                                                                  @"company",
                                                                  @"contactName",
                                                                  @"contactPhone",
                                                                  @"contactEmail",
                                                                  @"contactQQ",
                                                                  @"promulgatorID"]];
        [jobArray addObject:j];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:jobArray options:NSJSONWritingPrettyPrinted error:nil];
    [fm createFileAtPath:dataPath contents:data attributes:nil];
    return YES;
}

+ (BOOL)addJob:(ICJob*)job {
    ICJobFavoritesJobList *list = [ICJobFavoritesJobList loadData];
    for (ICJob *j in list.favoritesList) {
        if (j.index == job.index) {
            return NO;
        }
    }
    [list.favoritesList addObject:job];
    [list writeData];
    return YES;
}

- (BOOL)deleteJob:(ICJob*)job {
    [self.favoritesList removeObject:job];
    [self writeData];
    return YES;
}

+ (BOOL)checkJob:(ICJob*)job {
    ICJobFavoritesJobList *list = [ICJobFavoritesJobList loadData];
    for (ICJob *j in list.favoritesList) {
        if (j.index == job.index) {
            return YES;
        }
    }
    return NO;
}

@end
