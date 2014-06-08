//
//  ICJobFavoritesJobList.m
//  iCampus
//
//  Created by Jerry Black on 14-5-28.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import "ICJobFavoritesJobList.h"
#import "ICJob.h"

@implementation ICJobFavoritesJobList

- (NSMutableArray *)favoritesList {
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
        return nil;
    }
    if (![fm changeCurrentDirectoryPath:@"ICJob"]) {
        if (![fm createDirectoryAtPath:@"ICJob"
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL]) {
            return nil;
        }
        if (![fm changeCurrentDirectoryPath:@"ICJob"]) {
            return nil;
        }
    }
    NSString *jobDirectory = [fm currentDirectoryPath];
    NSString *dataPath = [jobDirectory stringByAppendingPathComponent:@"FavoritesJobs.json"];
    if (![fm fileExistsAtPath:dataPath]) {
        if (![fm createFileAtPath:dataPath contents:nil attributes:nil]) {
            return nil;
        }
    }
    if (![fm isReadableFileAtPath:dataPath]) {
        return nil;
    }
    if (![fm isWritableFileAtPath:dataPath]) {
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
        NSDictionary *j = @{@"id"            : [NSString stringWithFormat:@"%lu", (unsigned long)job.index],
                            @"title"         : job.title,
                            @"description"   : job.description,
                            @"location"      : job.location,
                            @"qualifications": job.qualifications,
                            @"salary"        : job.salary,
                            @"company"       : job.company,
                            @"contactName"   : job.contactName,
                            @"contactPhone"  : job.contactPhone,
                            @"contactEmail"  : job.contactEmail,
                            @"contactQQ"     : job.contactQQ,
                            @"promulgatorID" : job.promulgatorID};
        [jobArray addObject:j];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:jobArray options:NSJSONWritingPrettyPrinted error:nil];
    [fm createFileAtPath:dataPath contents:data attributes:nil];
    return YES;
}

+ (BOOL)addJob:(ICJob*)job {
    ICJobFavoritesJobList *list = [ICJobFavoritesJobList loadData];
    if ([ICJobFavoritesJobList checkJob:job]) {
        return NO;
    }
    [list.favoritesList addObject:job];
    [list writeData];
    return YES;
}

+ (BOOL)deleteJob:(ICJob*)job {
    ICJobFavoritesJobList *list = [ICJobFavoritesJobList loadData];
    for (ICJob *j in list.favoritesList) {
        if (j.index == job.index) {
            [list.favoritesList removeObject:j];
            [list writeData];
            return YES;
        }
    }
    return NO;
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
