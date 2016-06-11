//
//  LATNetAFNRequest.m
//  LATNetworking
//
//  Created by Later on 16/4/7.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "LATNetAFNRequestManager.h"
#import "LATNetWorking.h"
#import "AFHTTPSessionManager.h"
@interface LATNetAFNRequestManager ()
@property (nonatomic, strong) NSCache *sessionManagerCache;
@end
@implementation LATNetAFNRequestManager
static LATNetAFNRequestManager *sharedNetManager;
+ (LATNetAFNRequestManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedNetManager = [[self alloc] init]; });
    return sharedNetManager;
}

- (instancetype)init {
    if (!sharedNetManager) { sharedNetManager = [super init]; }
    return sharedNetManager;
}
/**
 *
 *  发起数据请求
 *
 *  @param requestMethod     数据请求方式 “GET/POST/PUT/PATCH/DELETE/HEAD”
 *  @param requestURLString  数据请求url
 *  @param requestParameters 数据请求parameters
 *  @param success           数据请求成功
 *  @param failure           数据请求失败
 *
 *  @return 数据请求的dataTash
 */
- (NSURLSessionDataTask *)startRequestWithMethod:(NSString *)requestMethod
                                requestURLString:(NSString *)requestURLString
                               requestParameters:(NSDictionary *)requestParameters
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    return [self startRequestWithMethod:requestMethod requestURLString:requestURLString requestParameters:requestParameters progress:nil success:success failure:failure];
}
/**
 *
 *  发起数据请求
 *
 *  @param requestMethod     数据请求方式 “GET/POST/HEAD/PUT/PATCH/DELETE”
 *  @param requestURLString  数据请求url
 *  @param requestParameters 数据请求parameters
 *  @param uploadProgress    数据请求进度
 *  @param success           数据请求成功
 *  @param failure           数据请求失败
 *
 *  @return 数据请求的dataTask
 */
- (NSURLSessionDataTask *)startRequestWithMethod:(NSString *)requestMethod
                                requestURLString:(NSString *)requestURLString
                               requestParameters:(NSDictionary *)requestParameters
                                        progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    return [self startRequestWithMethod:requestMethod requestURLString:requestURLString requestParameters:requestParameters requestPostFileDatas:nil requestCachePolicy:NSURLRequestUseProtocolCachePolicy timeOutInterval:60.f httpFields:nil progress:uploadProgress success:success failure:failure];
}
/**
 *
 *  发起数据请求
 *
 *  @param requestMethod        数据请求方式 “GET/POST/HEAD/PUT/PATCH/DELETE”
 *  @param requestURLString     数据请求url
 *  @param requestParameters    数据请求poarameters
 *  @param requestPostFileDatas 数据请求发送的数据data
 *  @param cachePolicy          数据请求的NSURLRequestCachePolicy
 *  @param timeOutInterval      数据请求超时时间
 *  @param httpFields           数据请求的httpFields
 *  @param uploadProgress       数据请求进度
 *  @param success              数据请求成功
 *  @param failure              数据请求失败
 *
 *  @return 数据请求dataTask
 */
- (NSURLSessionDataTask *)startRequestWithMethod:(NSString *)requestMethod
                                requestURLString:(NSString *)requestURLString
                               requestParameters:(nullable NSDictionary *)requestParameters
                            requestPostFileDatas:(nullable NSArray<LATNetUploadFileData *> *)requestPostFileDatas
                              requestCachePolicy:(NSURLRequestCachePolicy)cachePolicy
                                 timeOutInterval:(NSTimeInterval)timeOutInterval
                                      httpFields:(nullable NSDictionary *)httpFields
                                        progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    AFHTTPRequestSerializer *requestSerializer = [self _lat_requestSerializerWithCachePolicy:cachePolicy timeOutInterval:timeOutInterval httpFields:httpFields];
    AFHTTPResponseSerializer *responseSerializer = [self _lat_responseSerializer];
    AFHTTPSessionManager *sessionManager = [self _lat_sessionManagerWithRequestURLString:requestURLString];
    if (!sessionManager) { return nil; }
    sessionManager.requestSerializer = requestSerializer;
    sessionManager.responseSerializer = responseSerializer;
    NSURLSessionDataTask *dataTask = nil;
    if ([requestMethod.uppercaseString isEqualToString:@"GET"]) {
        dataTask = [sessionManager GET:requestURLString
                            parameters:requestParameters
                              progress:uploadProgress
                               success:success
                               failure:failure];
        return dataTask;
    } else if ([requestMethod.uppercaseString isEqualToString:@"POST"]) {
        if (requestPostFileDatas) {
            void(^requestPostFileBlock)(id<AFMultipartFormData> _Nonnull formData) = ^(id<AFMultipartFormData> _Nonnull formData){
                [requestPostFileDatas enumerateObjectsUsingBlock:^(LATNetUploadFileData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [formData appendPartWithFileData:obj.data name:obj.name fileName:obj.fileName mimeType:obj.fileType];
                }];
            };
            dataTask = [sessionManager POST:requestURLString
                                 parameters:requestParameters
                  constructingBodyWithBlock:requestPostFileBlock
                                   progress:uploadProgress
                                    success:success
                                    failure:failure];
            return dataTask;
            
        }
        else{
            dataTask = [sessionManager POST:requestURLString
                                 parameters:requestParameters
                                   progress:uploadProgress
                                    success:success
                                    failure:failure];
            return dataTask;
        }
    } else if ([requestMethod.uppercaseString isEqualToString:@"HEAD"]) {
        dataTask = [sessionManager HEAD:requestURLString
                             parameters:requestParameters
                                success:^(NSURLSessionDataTask * _Nonnull task) {
                                    !success ?: success(task, nil);
                                }
                                failure:failure];
        return dataTask;
        
    } else if ([requestMethod.uppercaseString isEqualToString:@"PATCH"]) {
        dataTask = [sessionManager PATCH:requestURLString
                              parameters:requestParameters
                                 success:success
                                 failure:failure];
        return dataTask;
        
    }else if([requestMethod.uppercaseString isEqualToString:@"PUT"]) {
        dataTask = [sessionManager PUT:requestURLString
                            parameters:requestParameters
                               success:success
                               failure:failure];
        return dataTask;
        
    } else if ([requestMethod.uppercaseString isEqualToString:@"DELETE"]) {
        dataTask = [sessionManager DELETE:requestURLString
                               parameters:requestParameters
                                  success:success
                                  failure:failure];
        return dataTask;
    } else {
        NSLog(@"REQUEST METHOD WRONG!");
        return dataTask;
    }
}
/**
 *
 *  获取一个requestSerializer
 *
 *  @param cachePolicy  requestSerializer的缓存策略
 *  @param timeInterval 时间超时
 *  @param httpFields   httpFields
 *
 *  @return AFHTTPRequesterializer
 */
- (AFHTTPRequestSerializer *)_lat_requestSerializerWithCachePolicy:(NSURLRequestCachePolicy)cachePolicy timeOutInterval:(NSTimeInterval)timeInterval httpFields:(NSDictionary *)httpFields {
    /** 默认json */
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    /** 默认协议存储 */
    requestSerializer.cachePolicy = cachePolicy;
    
    /** 默认60s超时 */
    requestSerializer.timeoutInterval = timeInterval;
    /** 使用者 */
    /** httpHeaderFields */
    if (httpFields) {
        [httpFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    return requestSerializer;
    
}
/**
 *
 *  获取一个的SessionManager
 *
 *  @param URLString 使用其host作为缓存的key
 *
 *  @return
 */
- (AFHTTPSessionManager *)_lat_sessionManagerWithRequestURLString:(NSString *)URLString {
    AFHTTPSessionManager *sessionManager  = (AFHTTPSessionManager *)[self sessionManagerWithRequestURLString:URLString];
    if (!sessionManager) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        sessionConfiguration.HTTPMaximumConnectionsPerHost = LAT_MAX_HTTP_CONNECTION_PER_HOST;
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:URLString] sessionConfiguration:sessionConfiguration];
        [self cacheSessionManager:sessionManager forRequestURLString:URLString];
    }
    return sessionManager;
}

#pragma mark Serializer
/*!
 *
 *  数据请求的response解析设置
 *
 *  @default
 *   AFHTTPResponseSerializerJSON
 *
 *  @param netBLL netBLL
 *
 *  @return AFHTTPResponseSerializer
 */
- (AFHTTPResponseSerializer *)_lat_responseSerializer {
    /** 默认json */
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                 @"text/json",
                                                 @"text/html",
                                                 @"application/json",
                                                 @"text/javascript",
                                                 @"text/css",@"text/plain",nil];
    return responseSerializer;
}
- (AFHTTPSessionManager *)sessionManagerWithRequestURLString:(NSString *)urlString {
    
    if ([NSURL URLWithString:urlString].host) {
        return [self.sessionManagerCache objectForKey:[NSURL URLWithString:urlString].host];
    }
    return nil;
}
- (void)cacheSessionManager:(AFHTTPSessionManager *)sessionManager forRequestURLString:(NSString *)urlString {
    if (sessionManager && [NSURL URLWithString:urlString].host) {
        [self.sessionManagerCache setObject:sessionManager forKey:[NSURL URLWithString:urlString].host];
    }
}
#pragma mark setter/getter
- (NSCache *)sessionManagerCache {
    if (!_sessionManagerCache) {
        _sessionManagerCache = [[NSCache alloc] init];
    }
    return _sessionManagerCache;
}
@end
