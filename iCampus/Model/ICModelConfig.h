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

typedef NS_ENUM(NSUInteger, __ICAuthType) {
    ICAuthTypeUnknown = 0,
    ICAuthTypeOAuth = 1,
    ICAuthTypeCAS = 2
};

extern NSString *_ICDataAPIURLPrefix;
extern NSString *_ICEduAdminAPIURLPrefix;
extern NSString *_ICNewsAPIURLPrefix;
extern NSString *_ICOAuthAPIURLPrefix;
extern NSString *_ICCASAPIURLPrefix;
extern __ICAuthType _ICAuthType;

#   define ICAuthAPIURLPrefix                \
    ^ const NSString * {                     \
        switch (ICAuthType) {                \
            case ICAuthTypeCAS:              \
                return _ICCASAPIURLPrefix;   \
            case ICAuthTypeOAuth:            \
                return _ICOAuthAPIURLPrefix; \
            default:                         \
                return nil;                  \
        }                                    \
    }()
#   define ICAuthType               ((const __ICAuthType)_ICAuthType)
#   define ICAboutAPIURLPrefix      ((const NSString *)_ICDataAPIURLPrefix)
#   define ICBusAPIURLPrefix        ((const NSString *)_ICDataAPIURLPrefix)
#   define ICCampusAPIURLPrefix     ((const NSString *)_ICDataAPIURLPrefix)
#   define ICClassTableAPIURLPrefix ((const NSString *)_ICEduAdminAPIURLPrefix)
#   define ICFreeRoomAPIURLPrefix   ((const NSString *)_ICEduAdminAPIURLPrefix)
#   define ICGradeAPIURLPrefix      ((const NSString *)_ICEduAdminAPIURLPrefix)
#   define ICGroupAPIURLPrefix      ((const NSString *)_ICDataAPIURLPrefix)
#   define ICJobAPIURLPrefix        ((const NSString *)_ICDataAPIURLPrefix)
#   define ICMapAPIURLPrefix        ((const NSString *)_ICDataAPIURLPrefix)
#   define ICNewsAPIURLPrefix       ((const NSString *)_ICNewsAPIURLPrefix)
#   define ICSchoolAPIURLPrefix     ((const NSString *)_ICDataAPIURLPrefix)
#   define ICUsedGoodAPIURLPrefix   ((const NSString *)_ICDataAPIURLPrefix)
#   define ICUserAPIURLPrefix       ((const NSString *)_ICDataAPIURLPrefix)
#   define ICYellowPageAPIURLPrefix ((const NSString *)_ICDataAPIURLPrefix)

//=====================================================================

#   pragma mark - Other configs

static const NSString *ICTimeZoneName = @"Asia/Shanghai";


//=====================================================================