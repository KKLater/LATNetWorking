//
//  LATNetResponseCache.h
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/4/8.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LATNetRequestEnitity;
@interface LATNetResponseCache : NSObject
/**
 *
 *  取网络缓存
 *
 *  @param request 网络请求
 *
 *  @return 缓存的数据
 */
+ (id)responseCacheForRequest:(LATNetRequestEnitity *)request;
/**
 *
 *  对网络做缓存
 *
 *  @param response 网络请求的数据
 *  @param request  网络请求
 */
+ (void)cacheResponse:(NSObject<NSCoding> *)response forRequest:(LATNetRequestEnitity *)request;
@end
