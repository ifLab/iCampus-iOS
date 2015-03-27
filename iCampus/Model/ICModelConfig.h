//
//  ICModuleConfig.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-12.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "../ICConfig.h"

//=====================================================================

#   pragma mark - Debug options

#   define IC_DATA_MODULE_DEBUG
#   ifdef IC_DATA_MODULE_DEBUG
#       define IC_ABOUT_DATA_MODULE_DEBUG
#       define IC_CAMPUS_DATA_MODULE_DEBUG
#       define IC_SCHOOL_DATA_MODULE_DEBUG
#       ifdef IC_SCHOOL_DATA_MODULE_DEBUG
#           define IC_SCHOOL_LIST_DATA_MODULE_DEBUG
#           define IC_SCHOOL_DETAIL_DATA_MODULE_DEBUG
#       endif
#       define IC_NEWS_DATA_MODULE_DEBUG
#       ifdef IC_NEWS_DATA_MODULE_DEBUG
#           define IC_NEWS_CHANNEL_DATA_MODULE_DEBUG
#           define IC_NEWS_LIST_DATA_MODULE_DEBUG
#           define IC_NEWS_DETAIL_DATA_MODULE_DEBUG
#       endif
#       define IC_BUS_DATA_MODULE_DEBUG
#       define IC_USER_DATA_MODULE_DEBUG
#       define IC_YELLOWPAGE_DATA_MODULE_DEBUG
#       ifdef IC_YELLOWPAGE_DATA_MODULE_DEBUG
#           define IC_YELLOWPAGE_DEPARTMENT_DATA_MODULE_DEBUG
#           define IC_YELLOWPAGE_CONTACT_DATA_MODULE_DEBUG
#       endif
#       define IC_JOB_DATA_MODULE_DEBUG
#       ifdef IC_JOB_DATA_MODULE_DEBUG
#           define IC_JOB_LIST_DATA_MODULE_DEBUG
#           define IC_JOB_DETAIL_DATA_MODULE_DEBUG
#           define IC_JOB_CLASSIFICATION_DATA_MODULE_DEBUG
#           define IC_JOB_PUBLISH_DATA_MODULE_DEBUG
#       endif
#   endif

//=====================================================================

#   pragma mark - App key & password

static const NSString *ICAppKey  = @"5d0c0d2c72f41a1b85af662c519e77d1";
static const NSString *ICAppPass = @"a9d9edb932a26f47576e8b4739404285";

//=====================================================================

#   pragma mark - Server domains definations

typedef NS_ENUM(NSUInteger, _ICAuthType) {
    ICAuthTypeUnknown = 0,
    ICAuthTypeOAuth = 1,
    ICAuthTypeCAS = 2
};

static NSString *ICDataAPIURLPrefix = @"http://m.bistu.edu.cn/api";
static NSString *ICEduAdminAPIURLPrefix = @"http://m.bistu.edu.cn/api";
static NSString *ICNewsAPIURLPrefix = @"http://m.bistu.edu.cn/newsapi";
static NSString *ICOAuthAPIURLPrefix = @"https://222.249.250.89:8443";
static NSString *ICCASAPIURLPrefix = @"https://222.249.250.89:8443";
static _ICAuthType ICAuthType = ICAuthTypeUnknown;

#   define ICAuthAPIURLPrefix                \
    ^ NSString * {                           \
        switch (ICAuthType) {                \
            case ICAuthTypeCAS:              \
                return ICCASAPIURLPrefix;    \
            case ICAuthTypeOAuth:            \
                return ICOAuthAPIURLPrefix;  \
            default:                         \
                return nil;                  \
        }                                    \
    }()
#   define ICAboutAPIURLPrefix      ICDataAPIURLPrefix
#   define ICBusAPIURLPrefix        ICDataAPIURLPrefix
#   define ICCampusAPIURLPrefix     ICDataAPIURLPrefix
#   define ICClassTableAPIURLPrefix ICEduAdminAPIURLPrefix
#   define ICFreeRoomAPIURLPrefix   ICEduAdminAPIURLPrefix
#   define ICGradeAPIURLPrefix      ICEduAdminAPIURLPrefix
#   define ICGroupAPIURLPrefix      ICDataAPIURLPrefix
#   define ICJobAPIURLPrefix        ICDataAPIURLPrefix
#   define ICMapAPIURLPrefix        ICDataAPIURLPrefix
#   define ICNewsAPIURLPrefix       ICNewsAPIURLPrefix
#   define ICSchoolAPIURLPrefix     ICDataAPIURLPrefix
#   define ICUsedGoodAPIURLPrefix   ICDataAPIURLPrefix
#   define ICUserAPIURLPrefix       ICDataAPIURLPrefix
#   define ICYellowPageAPIURLPrefix ICDataAPIURLPrefix

//=====================================================================

#   pragma mark - Other configs

static const NSString *ICTimeZoneName = @"Asia/Shanghai";


//=====================================================================