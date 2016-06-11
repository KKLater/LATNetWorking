//
//  LATNetBLLManager.m
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/3/18.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "LATNetRequestAction.h"
#import "LATNetWorking.h"
#import "LATNetAFNRequestManager.h"
#import "LATNetReachability.h"
#import "LATNetResponseCache.h"
#import "LATNetRequestEnitity.h"
#import "NSObject+LATNetMJExtensionCategory.h"

/**
 *
 *  获取RequestManager
 *
 *  @return 获取当前使用的RequestManager
 */
static inline LATNetAFNRequestManager * RequestManager () {
    return [LATNetAFNRequestManager sharedManager];
}
static inline dispatch_queue_t lat_net_task_creation_queue() {
    static dispatch_queue_t lat_net_task_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lat_net_task_creation_queue =
        dispatch_queue_create("later.com.networking.creation", DISPATCH_QUEUE_SERIAL);
    });
    return lat_net_task_creation_queue;
}
static LATNetRequestAction *shareNetAction       = nil;
@interface LATNetRequestAction ()

/*!
 *
 *  数据请求任务的缓存，开始任务之前，依据[RequestEnitity hash]生成key；任务开启后，将任务存储；请求结束，将任务移除
 *   重复任务的判定依据就是这个cache里面有没有该任务
 */
@property (nonatomic, strong) NSCache *sessionTaskCache;

@end
@implementation LATNetRequestAction
#pragma mark - Init
+ (LATNetRequestAction *)shareAction {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ shareNetAction = [[self alloc] init]; });
    return shareNetAction;
}
- (instancetype)init {
    if (!shareNetAction) { shareNetAction = [super init]; }
    return shareNetAction;
}

#pragma mark startRequest
/*!
 *
 *  根据数据请求体发起一个数据请求
 *
 *  @param Request 数据请求体
 */
+ (void)startRequest:(LATNetRequestEnitity *)request {
    NSParameterAssert(request);
    if (![LATNetReachability isReachable]) {
        LAT_Net_Log(@"网络连接失败");
        /** 已经在请求中了 */
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"囧，你的网络走失了..." };
        NSError *noNetError = [NSError errorWithDomain:NSURLErrorDomain
                                                  code:NSURLErrorNotConnectedToInternet
                                              userInfo:userInfo];
        [self _lat_requestFailure:request error:noNetError];
        return;
    }
    [self _lat_startSingleRequest:request completionGroup:nil];
}

+ (void)_lat_startSingleRequest:(LATNetRequestEnitity *)requestEnitity completionGroup:(dispatch_group_t)completionGroup {
    NSParameterAssert(requestEnitity);
    
    /** 取缓存 */
    id cacheData = [LATNetResponseCache responseCacheForRequest:requestEnitity];
    if (cacheData) {
        if (!requestEnitity.responseClass) {
            !requestEnitity.LATRequestResultBlock ?: requestEnitity.LATRequestResultBlock(cacheData, nil, nil);
        } else {
            if ([cacheData isKindOfClass:[NSDictionary class]]) {
                NSObject * respondObject = (NSObject *)[requestEnitity.responseClass responseObjectWithResponse:((NSDictionary *)cacheData)];
                /** 请求返回 */
                !requestEnitity.LATRequestResultBlock ?: requestEnitity.LATRequestResultBlock(cacheData, respondObject, nil);
            }
        }
    }    
    __weak typeof(self)weakSelf = self;
    NSString *hashKey    = [NSString stringWithFormat:@"%@", @([requestEnitity hash])];
    if ([[self shareAction].sessionTaskCache objectForKey:hashKey]) {
        /** 已经在请求中了 */
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"正在请求中，请不要重复请求" };
        NSError *cancelError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
        [self _lat_requestFailure:requestEnitity error:cancelError];
        return;
    }
    
    /** 接收成功的block */
    void (^requestSuccess)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        __strong typeof(weakSelf)self = weakSelf;
        if ([UIApplication sharedApplication].networkActivityIndicatorVisible) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        [self _lat_requestSuccess:requestEnitity responseData:responseObject];
    };
    /** 接收失败的block */
    void (^requestFailure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        __strong typeof(weakSelf)self = weakSelf;
        if ([UIApplication sharedApplication].networkActivityIndicatorVisible) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        [self _lat_requestFailure:requestEnitity error:error];
    };
    /** 进度block */
    void (^requestProgress)(NSProgress * _Nonnull progress)
    = ^(NSProgress * _Nonnull progress){
        __strong typeof(weakSelf)self = weakSelf;
        /** 总量为0，计算个毛进度 */
        if (progress.totalUnitCount <= 0) { return; }
        [self _lat_requestProgress:requestEnitity progress:progress];
    };
    
    /** 网络标示 */
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:requestEnitity.networkActivityIndicatorVisible];
    dispatch_async(lat_net_task_creation_queue(), ^{
        NSURLSessionDataTask *dataTask =
        [RequestManager() startRequestWithMethod:[self _lat_requestMethodWithType:requestEnitity.requestMethodType]
                                requestURLString:requestEnitity.requestURLString
                               requestParameters:requestEnitity.requestParameters
                            requestPostFileDatas:requestEnitity.requestPostFileDatas
                              requestCachePolicy:requestEnitity.requestCachePolicy
                                 timeOutInterval:requestEnitity.requestTimeoutInterval
                                      httpFields:requestEnitity.HTTPHeaderFields
                                        progress:requestProgress
                                         success:requestSuccess
                                         failure:requestFailure];
        if (dataTask) {
            [[self shareAction].sessionTaskCache setObject:dataTask forKey:hashKey];
        }
    });
}
+ (NSString *)_lat_requestMethodWithType:(LATNetRequestMethodType)type {
    switch (type) {
        case LATNetRequestMethodTypeGET: {
            return @"GET";
            break;
        }
        case LATNetRequestMethodTypePOST: {
            return @"POST";
            break;
        }
        case LATNetRequestMethodTypeHEAD: {
            return @"HEAD";
            break;
        }
        case LATNetRequestMethodTypePATCH: {
            return @"PATCH";
            break;
        }
        case LATNetRequestMethodTypePUT: {
            return @"PUT";
            break;
        }
        case LATNetRequestMethodTypeDELETE: {
            return @"DELETE";
            break;
        }
    }
}
+ (void)cancelRequest:(LATNetRequestEnitity *)request {
    dispatch_async(lat_net_task_creation_queue(), ^{
        NSString *hashKey = [@([request hash]) stringValue];
        NSURLSessionDataTask *dataTask = [[self shareAction].sessionTaskCache objectForKey:hashKey];
        [[self shareAction].sessionTaskCache removeObjectForKey:hashKey];
        if (dataTask) {  [dataTask cancel]; }
        request.LATRequestProgressBlock = nil;
        request.LATRequestResultBlock = nil;
    });
}

#pragma mark request Completion 
/**
 *
 *  数据请求成功处理
 *
 *  @param request      数据请求的requestEnitity
 *  @param responseData 数据请求返回结果
 */
+ (void)_lat_requestSuccess:(LATNetRequestEnitity *)request responseData:(nullable id)responseData {
    /** 空数据,直接返回 */
    if (!responseData) {
        [self _lat_requestFailure:request error:nil];
        return;
    }
    NSDictionary *responseDic = responseData;
    NSObject* respondObject = nil;
    /** NSData解析 */
    if (![NSJSONSerialization isValidJSONObject:responseData]) {
        if ([responseData isKindOfClass:[NSData class]]) {
            responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        }
    }
    /** 存储 */
    LAT_Net_Log(@"responseData %@",responseDic);
    /** 默认存储策略是内存加磁盘 */
    [LATNetResponseCache cacheResponse:responseDic forRequest:request];
    if ([responseDic isKindOfClass:[NSDictionary class]]) {
        respondObject = (NSObject *)[request.responseClass responseObjectWithResponse:responseDic];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        !request.LATRequestResultBlock ?: request.LATRequestResultBlock(responseDic, respondObject, nil);
        [self cancelRequest:request];
    });
}
/**
 *
 *  数据请求失败的处理
 *
 *  @param request 数据请求RequestEnitity
 *  @param error   数据请求失败error
 */
+ (void)_lat_requestFailure:(LATNetRequestEnitity *)request error:(NSError *)error {
    //DO FAILURE
    NSString *errDescription = @"哎呀，你的请求已经走丢了...";
    if (error.code >= 300 && error.code <= 399) {
        errDescription = @"哎呀，你的请求已经走丢了...";
    }else if (error.code >= 400 && error.code <= 499) {
        errDescription = @"400";
    }else if (error.code >= 500 && error.code <= 599) {
        errDescription = @"500";
    } else if(error.code == -1009) {
        errDescription = @"囧，你的网络走丢在了雾霾中...";
    }
    LATNetError *netError = [LATNetError netErrorWithCode:error.code desc:errDescription detailErr:error];
    netError.entityName = NSStringFromClass(request.responseClass);
    dispatch_async(dispatch_get_main_queue(), ^{
        !request.LATRequestResultBlock ?: request.LATRequestResultBlock(nil, nil, netError);
        [self cancelRequest:request];
        
    });
}

/**
 *
 *  数据请求进度
 *
 *  @param request  数据请求的RequestEnitity
 *  @param progress 数据请求进度
 */
+ (void)_lat_requestProgress:(LATNetRequestEnitity *)request progress:(NSProgress *)progress {
    //DO PROGRESS
    dispatch_async(dispatch_get_main_queue(), ^{
        !request.LATRequestProgressBlock ?: request.LATRequestProgressBlock(progress);
    });
}
#pragma mark publicMethod

- (NSCache *)sessionTaskCache {
    if (!_sessionTaskCache) {
        _sessionTaskCache = [[NSCache alloc] init];
    }
    return _sessionTaskCache;
}
@end
