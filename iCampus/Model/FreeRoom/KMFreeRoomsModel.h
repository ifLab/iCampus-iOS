//
//  KMFreeRooms.h
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14/10/20.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Object

@interface KMCampusObject : NSObject

@property (strong, nonatomic) NSString *campusID;
@property (strong, nonatomic) NSString *campusCode;
@property (strong, nonatomic) NSString *campusName;
@property (strong, nonatomic) NSString *campusShortName;

@end

@interface KMBuildingObject : NSObject

@property (strong, nonatomic) NSString *buildingID;
@property (strong, nonatomic) NSString *buildingCode;
@property (strong, nonatomic) NSString *buildingName;

@end

@interface KMRoomObject : NSObject

@property (strong, nonatomic) NSString *roomCode;
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *roomCapacity;

@end

@interface KMRoomDetail : NSObject

@property (nonatomic) NSInteger order;
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *courseCollage;
@property (strong, nonatomic) NSString *courseCredits;
@property (strong, nonatomic) NSString *courseTeacher;

@end

#pragma mark - Model

@interface KMFreeRoomsModel : NSObject

+ (void)getCampusList:(void(^)(BOOL success, NSArray *data, NSError *error))result;
+ (void)getBuildingListWithCampusID:(NSString *)campusID :(void(^)(BOOL success, NSArray *data, NSError *error))result;
+ (void)getRoomListWithBuildingID:(NSString *)buildingID :(void(^)(BOOL success, NSArray *data, NSError *error))result;
+ (id)getRoomDetailWithRoomID:(NSString *)roomID atDate:(NSString *)date;

@end
