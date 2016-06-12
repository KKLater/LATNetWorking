//
//  NSObject+LATNetRequestEnitityCatagory.h
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/6/12.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LATNetError, LATNetUploadFileData;

typedef NS_ENUM(NSInteger, LATNetRequestMethodType) {
    LATNetRequestMethodTypeGET,//b
    LATNetRequestMethodTypePOST,
    LATNetRequestMethodTypeHEAD,//b
    LATNetRequestMethodTypePATCH,
    LATNetRequestMethodTypePUT,
    LATNetRequestMethodTypeDELETE//b
};
typedef NS_ENUM(NSInteger, LATNetCacheType) {
    LATNetCacheTypeMemoryAndDisk,
    LATNetCacheTypeMemory,
    LATNetCacheTypeNone
};
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (LATNetRequestEnitityCatagory)
#pragma mark RequestEnitity
/**
 *
 *  网络请求的domainType类型，设置位于LATNetWorking.h中
 *  用于获取网络请求的域名
 *  域名获取原理：NSString *netDomain = LATDomainDic[LATNetDomainTypeBBS].stringDomain;
 */
@property (nonatomic, assign) LATNetDomainType requestDomainType;
/**
 *  @author Later, 16-04-06 11:04
 *
 *  网络请求的serverName
 */
@property (assign, nonatomic) LATNetServerNameType requestServerNameType;
/**
 *
 *  网络请求方式'GET'/'POST'/'HEAD'/'PATCH'/'PUT'/'DELETE'
 *  默认：'LATNetRequestMethodTypyPOST' -> 'post'请求
 */
@property (nonatomic, assign) LATNetRequestMethodType requestMethodType;
/**
 *
 *  数据请求超时
 */
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;
/**
 *
 *  上传数据
 */
@property (nonatomic, strong) NSArray<LATNetUploadFileData *> *requestPostFileDatas;
/**
 *
 *  网络请求标示
 */
@property (nonatomic, assign) BOOL networkActivityIndicatorVisible;
/**
 *
 *  协议层存储策略
 */
@property (nonatomic, assign) NSURLRequestCachePolicy requestCachePolicy;
/**
 *
 *  HTTPHeaderFields
 */
@property (nonatomic, strong) NSDictionary *HTTPHeaderFields;
/**
 *
 *  请求成功的block
 */
@property (nullable, nonatomic, copy) void(^LATRequestResultBlock)(id _Nullable responseData,id _Nullable responseObject, LATNetError *_Nullable httpError);
/**
 *
 *  请求进度block
 */
@property (nullable, nonatomic, copy) void(^LATRequestProgressBlock)(NSProgress * _Nullable progress);

/**
 *
 *  数据请求的URL
 */
@property (nonatomic, copy, readonly) NSString *requestURLString;
/**
 *
 *  数据请求参数表
 */
@property (nonatomic, copy, readonly) NSDictionary *requestParameters;

#pragma mark about response
/**
 *
 *  请求结果的存储策略
 */
@property (nonatomic, assign) LATNetCacheType responseCacheType;

/** 响应的class */
@property (nonatomic, weak) Class responseClass;

#pragma mark about request
/**
 *
 *  发起请求
 */
- (void)startRequest;
/**
 *
 *  停止请求
 */
- (void)cancelRequest;
/**
 *
 *  设置domainType和serverName
 *
 *  @param domainType domainType
 *  @param serverName serverName
 */
- (void)setRequestDomainType:(LATNetDomainType)domainType serverNameType:(LATNetServerNameType)serverNameType;

@end
NS_ASSUME_NONNULL_END
