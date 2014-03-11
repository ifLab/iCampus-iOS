//
//  ICMap.h
//  iCampus
//
//  Created by Kwei Ma on 14-3-10.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICMap : NSObject

- (NSArray *)mapList;
- (NSDictionary *)informationWithAreaID:(NSString *)idstring;

@end

#define ICMapLongitude @"ICMapLongitude"
#define ICMapLatitude @"ICMapLatitude"
#define ICMapZoomLevel @"ICMapZoomLevel"
#define ICMapIDStr @"ICMapZoomIDStr"
#define ICMapName @"ICMapName"
#define ICMapAddress @"ICMapAddress"
#define ICMapZipCode @"ICMapZipCOde"