//
//  LATNetReachability.h
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/4/8.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LATNetReachabilityStatus) {
    LATNetReachabilityStatusUnknown          = -1,
    LATNetReachabilityStatusNotReachable     = 0,
    LATNetReachabilityStatusReachableViaWWAN = 1,
    LATNetReachabilityStatusReachableVia2G   = 2,
    LATNetReachabilityStatusReachableVia3G   = 3,
    LATNetReachabilityStatusReachableVia4G   = 4,
    LATNetReachabilityStatusReachableViaWiFi
};
@interface LATNetReachability : NSObject
/**
 *
 *  网络是否连接
 *
 *  @return 网络是否连接
 */
+ (BOOL)isReachable;
/**
 *
 *  网络连接状态
 *
 *  @return 网络连接状态
 */
+ (LATNetReachabilityStatus)status;
@end
