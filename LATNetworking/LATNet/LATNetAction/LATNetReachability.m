//
//  LATNetReachability.m
//  LATNetworkingDemo
//
//  Created by Later on 16/4/8.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "LATNetReachability.h"
#import "Reachability.h"

@implementation LATNetReachability
+ (BOOL)isReachable {
    if (LATNetReachabilityStatusNotReachable == [self status] || LATNetReachabilityStatusUnknown == [self status])
    {
        return NO;
    }else{
        return YES;
    }
}

+ (LATNetReachabilityStatus)status {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    NetworkStatus status=[reach currentReachabilityStatus];
    switch (status)
    {
        case NotReachable:
            return LATNetReachabilityStatusNotReachable;
        case ReachableViaWWAN:
            return LATNetReachabilityStatusReachableViaWWAN;
        case ReachableVia2G:
            return LATNetReachabilityStatusReachableVia2G;
        case ReachableVia3G:
            return LATNetReachabilityStatusReachableVia3G;
        case ReachableVia4G:
            return LATNetReachabilityStatusReachableVia4G;
        case ReachableViaWiFi:
            return LATNetReachabilityStatusReachableViaWiFi;
        default:
            return LATNetReachabilityStatusUnknown;
    }
}
@end
