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
#   endif

//=====================================================================

#   pragma mark - App key & password

static const NSString *ICAppKey  = @"5d0c0d2c72f41a1b85af662c519e77d1";
static const NSString *ICAppPass = @"a9d9edb932a26f47576e8b4739404285";

//=====================================================================

#   pragma mark - Server domains definations

static const NSString *ICServerDomain    = @"api.bistu.edu.cn";
static const NSString *ICOldServerDomain = @"m.bistu.edu.cn"  ;

#   define ICAboutServerDomain      ICOldServerDomain
#   define ICSchoolServerDomain     ICServerDomain
#   define ICNewsServerDomain       ICServerDomain
#   define ICBusServerDomain        ICOldServerDomain
#   define ICCampusServerDomain     ICServerDomain
#   define ICUserServerDomain       ICServerDomain
#   define ICYellowPageServerDomain ICOldServerDomain

//=====================================================================

#   pragma mark - Other configs

static const NSString *ICTimeZoneName = @"Asia/Shanghai";


//=====================================================================