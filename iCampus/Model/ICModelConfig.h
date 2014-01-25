//
//  ICModuleConfig.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-12.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//
//=====================================================================

#   pragma mark - Debug options

//#   define __IC_ERROR_ONLY_DEBUG__
#   define __IC_DATA_MODULE_DEBUG__
#   ifdef __IC_DATA_MODULE_DEBUG__
#       define __IC_CAMPUS_MODULE_DEBUG__
#       define __IC_SCHOOL_MODULE_DEBUG__
#       ifdef __IC_SCHOOL_MODULE_DEBUG__
#           define __IC_SCHOOL_MODULE_LIST_DEBUG__
#           define __IC_SCHOOL_MODULE_DETAIL_DEBUG__
#       endif
#       define __IC_NEWS_MODULE_DEBUG__
#       ifdef __IC_NEWS_MODULE_DEBUG__
#           define __IC_NEWS_MODULE_CHANNEL_DEBUG__
#           define __IC_NEWS_MODULE_LIST_DEBUG__
#           define __IC_NEWS_MODULE_DETAIL_DEBUG__
#       endif
#       define __IC_BUS_MODULE_DEBUG__
#       define __IC_USER_MODULE_DEBUG__
#       define __IC_YELLOWPAGE_MODULE_DEBUG__
#       ifdef __IC_YELLOWPAGE_MODULE_DEBUG__
#           define __IC_YELLOWPAGE_MODULE_DEPARTMENT_DEBUG__
#           define __IC_YELLOWPAGE_MODULE_CONTACT_DEBUG__
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

#   pragma mark - Static strings for debug

static const NSString *ICCampusTag               = @"[CAMPUS]"               ;
static const NSString *ICSchoolListTag           = @"[SCHOOL|LIST]"          ;
static const NSString *ICSchoolDetailTag         = @"[SCHOOL|DETAIL]"        ;
static const NSString *ICNewsChannelTag          = @"[NEWS|CHANNEL]"         ;
static const NSString *ICNewsListTag             = @"[NEWS|LIST]"            ;
static const NSString *ICNewsDetailTag           = @"[NEWS|DETAIL]"          ;
static const NSString *ICBusTag                  = @"[BUS]"                  ;
static const NSString *ICUserTag                 = @"[USER]"                 ;
static const NSString *ICYellowPageDepartmentTag = @"[YELLOWPAGE|DEPARTMENT]";
static const NSString *ICYellowPageListTag       = @"[YELLOWPAGE|LIST]"      ;

static const NSString *ICFetchingTag  = @"<FETCHING>"  ;
static const NSString *ICSucceededTag = @"<SUCCEEDED>" ;
static const NSString *ICFailedTag    = @"<FAILED>"    ;

static const NSString *ICBrokenTag = @"(BROKEN)";
static const NSString *ICNullTag   = @"(NULL)"  ;

//=====================================================================