//
//  KMFreeRooms.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14/10/20.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMFreeRoomsModel.h"
#import "AFNetworking.h"

@implementation KMCampusObject
@end

@implementation KMBuildingObject
@end

@implementation KMRoomObject
@end

@implementation KMRoomDetail
@end

#pragma mark - Model

@interface KMFreeRoomsModel ()

@end

@implementation KMFreeRoomsModel

+ (void)getCampusList:(void (^)(BOOL, NSArray *, NSError *))result
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://jwcapi.iflab.org/district.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *preparedData = [@[] mutableCopy];
            for (NSDictionary *dict in responseObject) {
                KMCampusObject *obj = [KMCampusObject new];
                obj.campusID = dict[@"id"];
                obj.campusCode = dict[@"districtCode"];
                obj.campusName = dict[@"districtName"];
                obj.campusShortName = dict[@"districtshortName"];
                
                [preparedData addObject:obj];
            }
            result(YES, [preparedData copy], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(NO, nil, error);
    }];
}

+ (void)getBuildingListWithCampusID:(NSString *)campusID :(void (^)(BOOL, NSArray *, NSError *))result
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paras = @{@"districtCode": campusID};
    [manager GET:@"http://jwcapi.iflab.org/building.php" parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *preparedData = [@[] mutableCopy];
            for (NSDictionary *dict in responseObject) {
                KMBuildingObject *obj = [KMBuildingObject new];
                obj.buildingID = dict[@"id"];
                obj.buildingCode = dict[@"buildingCode"];
                obj.buildingName = dict[@"buildingName"];
                
                [preparedData addObject:obj];
            }
            result(YES, [preparedData copy], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(NO, nil, error);
    }];
}

+ (void)getRoomListWithBuildingID:(NSString *)buildingID :(void (^)(BOOL, NSArray *, NSError *))result
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paras = @{@"buildingCode": buildingID};
    [manager GET:@"http://jwcapi.iflab.org/classroom.php" parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *preparedData = [@[] mutableCopy];
            for (NSDictionary *dict in responseObject) {
                KMRoomObject *obj = [KMRoomObject new];
                obj.roomCode = dict[@"jsbh"];
                obj.roomName = dict[@"jsmc"];
                obj.roomCapacity = dict[@"zws"];
                
                [preparedData addObject:obj];
            }
            result(YES, [preparedData copy], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(NO, nil, error);
    }];
}

//+ (void)getRoomDetailWithRoomID:(NSString *)roomID :(void (^)(BOOL, NSArray *, NSError *))result
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone localTimeZone];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSDictionary *paras = @{@"jsbh": roomID, @"date": [formatter stringFromDate:[NSDate date]]};
//    [manager GET:@"http://jwcapi.iflab.org/classinfo.php" parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject isKindOfClass:[NSArray class]]) {
//            NSMutableArray *preparedData = [@[] mutableCopy];
//            for (NSDictionary *dict in responseObject) {
//                KMRoomDetail *obj = [KMRoomDetail new];
//                NSLog(@"%@", dict);
//                obj.order = [dict[@"sjd"] integerValue];
//                if (![dict[@"kcdm"] isKindOfClass:[NSNull class]]) {
//                    obj.courseName = dict[@"kcdm"][@"kczwmc"];
//                }
//                if (![dict[@"jsxx"] isKindOfClass:[NSNull class]]) {
//                    obj.courseTeacher = dict[@"jsxx"][@"xkkh"];
//                }
//                [preparedData addObject:obj];
//            }
//            result(YES, [preparedData copy], nil);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        result(NO, nil, error);
//    }];
//}

+ (id)getRoomDetailWithRoomID:(NSString *)roomID atDate:(NSString *)date
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSMutableString *URLString = [NSMutableString stringWithFormat:@"http://jwcapi.iflab.org/classinfo.php?jsbh=%@", roomID];
    [URLString appendFormat:@"&date=%@", date];
    NSLog(@"%@", URLString);
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL]
                                         returningResponse:nil
                                                     error:nil];
    if (!data) {
        return nil;
    }
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:nil];
    if (!json) {
        KMRoomDetail *course;
        for (NSInteger i = 0; i < 13 ; ++i) {
            course = [[KMRoomDetail alloc] init];
            [list addObject:course];
        }
        return list;
    }
    for (NSDictionary *j in json) {
        KMRoomDetail *course;
        for (NSInteger i = 0; i < 13 ; ++i) {
            course = [[KMRoomDetail alloc] init];
            [list addObject:course];
        }
        
        if ([j[@"sjd"] intValue] == 1) {
            course = list[0];
            course.order = 1;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
            course = list[1];
            course.order = 2;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
        }
        if ([j[@"sjd"] intValue] == 3) {
            course = list[2];
            course.order = 3;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
            course = list[3];
            course.order = 4;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
        }
        if ([j[@"sjd"] intValue] == 6) {
            course = list[5];
            course.order = 6;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
            course = list[6];
            course.order = 7;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
        }
        if ([j[@"sjd"] intValue] == 8) {
            course = list[7];
            course.order = 8;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
            course = list[8];
            course.order = 9;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
        }
        if ([j[@"sjd"] intValue] == 10) {
            course = list[9];
            course.order = 10;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
            course = list[10];
            course.order = 11;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
            course = list[11];
            course.order = 12;
            if (![j[@"kcdm"]isKindOfClass:[NSNull class]]) {
                course.courseName = j[@"kcdm"][@"kczwmc"];
                course.courseCollage = j[@"kcdm"][@"kcjj"];
                course.courseCredits = j[@"kcdm"][@"xf"];
            } else {
                course.courseName = @"";
                course.courseCollage = @"";
                course.courseCredits = @"";
            }
            if (![j[@"jsxx"]isKindOfClass:[NSNull class]]) {
                course.courseTeacher = j[@"jsxx"][@"xm"];
            } else {
                course.courseTeacher = @"";
            }
        }
    }
    return list;
}

@end
