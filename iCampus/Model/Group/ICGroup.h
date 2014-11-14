//
//  ICGroup.h
//  iCampus
//
//  Created by Rex Ma on 14-5-25.
//  Copyright (c) 2014年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICUser.h"

@interface ICGroup : UIViewController

+(ICUser *)personalInformation;
+(NSMutableArray *)personalInformationlist;
+(NSMutableArray *)personalDetailInformation;

@property (copy,nonatomic) NSString *index;
@property (copy,nonatomic) NSString *groupType;
@property (copy,nonatomic) NSString *groupName;
@property (copy,nonatomic) NSString *nclassName;
@property (copy,nonatomic) NSString *type;
@property (copy,nonatomic) NSString *userid;

@end
