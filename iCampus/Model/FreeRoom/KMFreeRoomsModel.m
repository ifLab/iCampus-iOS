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
    NSDictionary *paras = @{@"districtCode": buildingID};
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

+ (void)getRoomDetailWithRoomID:(NSString *)roomID :(void (^)(BOOL, NSArray *, NSError *))result
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paras = @{@"districtCode": roomID};
    [manager GET:@"http://jwcapi.iflab.org/classinfo.php" parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *preparedData = [@[] mutableCopy];
            for (NSDictionary *dict in responseObject) {
                KMRoomDetail *obj = [KMRoomDetail new];
                obj.order = [dict[@"xxxx"] integerValue];
                obj.courseName = dict[@"xxxxx"];
                obj.courseTeacher = dict[@"xxxxxx"];
                
                [preparedData addObject:obj];
            }
            result(YES, [preparedData copy], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(NO, nil, error);
    }];
}

@end
