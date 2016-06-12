//
//  LATNetResponseCache.m
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/4/8.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "LATNetResponseCache.h"
#import "LATNetWorking.h"
#import "NSObject+LATStringPropertyCategory.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation LATNetResponseCache

+ (id)responseCacheForRequest:(NSObject *)request{
    NSString *cacheKey = [self _lat_responseCacheKey:request];
    if (cacheKey) {
        NSObject * responseData;
        switch (request.responseCacheType) {
                /** 取本地存储数据 */
            case LATNetCacheTypeMemoryAndDisk:
            case LATNetCacheTypeMemory: {
                responseData = [[LATFileManager defaultManager] objectFromDiskForKey:cacheKey];
                return responseData;
                break;
            }
            case LATNetCacheTypeNone: {
                break;
            }
        }
    }
    return nil;
}
+ (void)cacheResponse:(NSObject<NSCoding> *)response forRequest:(NSObject *)request{
    /** 默认存储策略是内存加磁盘 */
    switch (request.responseCacheType) {
        case LATNetCacheTypeMemoryAndDisk: {
            [[LATFileManager defaultManager] setObject:response forKey:[self _lat_responseCacheKey:request]];
            break;
        }
        case LATNetCacheTypeMemory: {
            [[LATFileManager defaultManager] setObject:response forKey:[self _lat_responseCacheKey:request] toDisk:NO];
            break;
        }
        case LATNetCacheTypeNone: {
            break;
        }
    }
}
/**
 *
 *  请求结果缓存Key
 *
 *  @return cacheKey
 */

+ (NSString *)_lat_responseCacheKey:(NSObject *)request {
    NSString *domain = request.requestURLString;
    NSDictionary * parameters = [request propertyStringDictionary];
    NSString *paramtersString = [request propertyStringWithPropertyDic:parameters];
    NSString *unMD5Key = [NSString stringWithFormat:@"%@lat_com_later_net%@",domain,paramtersString];
    return [self _lat_md5String:unMD5Key];
}

+ (NSString *)_lat_md5String:(NSString *)string {
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
@end
