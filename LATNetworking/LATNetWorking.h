//
//  LATNetWorking.h
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/3/19.
//  Version 1.0.1
//  Copyright © 2016年 Later. All rights reserved.
//
#import <Foundation/Foundation.h>

/*!
 *
 *  网络请求的域名
 */
typedef struct _LATNetDomainDic {
    __unsafe_unretained NSString		*stringDomain;//域名地址
} LATNetDomainDic;
/*!
 *
 *  网络请求的所有域名
 */
static const LATNetDomainDic LATDomainDic[] = {
    {@"http://app.idaxiang.org/"}      
};
/*!
 *
 *  网络请求组件类型type枚举
 */
typedef NS_ENUM(NSInteger, LATNetDomainType) {
    LATDomainTypeDaXiang      =   0
};
typedef struct _LATNetServerNameDic {
    __unsafe_unretained NSString		*serverName;//serverName
    
}LATNetServerNameDic;
static const LATNetServerNameDic LATServerNameDic[] = {
    {@"/api/v1_0/art/info"},           //大象公会详情
};

typedef NS_ENUM(NSInteger, LATNetServerNameType) {
    LATNetServerNameTypeDaXiangNewsDetailInfo = 0,            //新闻详情
};

#ifndef LATNetWorking_h
#define LATNetWorking_h
#import "LATNetReachability.h"
#import "LATNetAFNRequestManager.h"
#import "LATNetUploadFileData.h"
#import "LATNetError.h"
#import "LATFileManager.h"
#import "UIApplication+LATNetCategory.h"
#import "NSObject+LATNetRequestEnitityCatagory.h"


#endif /* LATNetWorking_h */

/** 调试define */
//#define LAT_Server_Debug

#ifdef LAT_Server_Debug
#define LAT_Net_Log(fmt, ...)         NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define LAT_Net_Log(fmt, ...)
#endif


#ifndef LAT_NET_OUTTIMEINTERVAL
#define LAT_NET_OUTTIMEINTERVAL 60
#endif
#ifndef LAT_MAX_HTTP_CONNECTION_PER_HOST
#define LAT_MAX_HTTP_CONNECTION_PER_HOST 5
#endif

#ifndef LAT_NET_VERSION
#define LAT_NET_VERSION @"1.0.1"
#endif


