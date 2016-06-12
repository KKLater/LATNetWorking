//
//  NSObject+LATNetRequestEnitityCatagory.m
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/6/12.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "NSObject+LATNetRequestEnitityCatagory.h"
#import "NSObject+LATNetMJExtensionCategory.h"
#import "NSObject+LATStringPropertyCategory.h"
#import "LATNetRequestAction.h"
#import <objc/runtime.h>


@implementation NSObject (LATNetRequestEnitityCatagory)
- (void)startRequest {
    [LATNetRequestAction startRequest:self];
}
- (void)cancelRequest {
    [LATNetRequestAction cancelRequest:self];
}
- (void)setRequestDomainType:(LATNetDomainType)domainType serverNameType:(LATNetServerNameType)serverNameType {
    self.requestDomainType = domainType;
    self.requestServerNameType = serverNameType;
}
#pragma mark setter/getter
/** requestDomainType */
- (void)setRequestDomainType:(LATNetDomainType)requestDomainType {
    objc_setAssociatedObject(self, @selector(requestDomainType), @(requestDomainType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LATNetDomainType)requestDomainType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
/** requestServerName */
- (void)setRequestServerNameType:(LATNetServerNameType)requestServerNameType {
    objc_setAssociatedObject(self, @selector(requestServerNameType), @(requestServerNameType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (LATNetServerNameType)requestServerNameType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
    
}
/** requestMethodType */
- (void)setRequestMethodType:(LATNetRequestMethodType)requestMethodType {
    objc_setAssociatedObject(self, @selector(requestMethodType), @(requestMethodType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LATNetRequestMethodType)requestMethodType {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @(LATNetRequestMethodTypePOST), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [objc_getAssociatedObject(self, _cmd) integerValue];
    
}
/** requestTimeoutInterval */
- (void)setRequestTimeoutInterval:(NSTimeInterval)requestTimeoutInterval {
    objc_setAssociatedObject(self, @selector(requestTimeoutInterval), @(requestTimeoutInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)requestTimeoutInterval {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @(LAT_NET_OUTTIMEINTERVAL), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
/** requestPostFileDatas */
- (void)setRequestPostFileDatas:(NSArray<LATNetUploadFileData *> *)requestPostFileDatas {
    objc_setAssociatedObject(self, @selector(requestPostFileDatas), requestPostFileDatas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray<LATNetUploadFileData *> *)requestPostFileDatas {
    return objc_getAssociatedObject(self, _cmd);
}
/** 网络请求标示 */
- (void)setNetworkActivityIndicatorVisible:(BOOL)networkActivityIndicatorVisible {
    objc_setAssociatedObject(self, @selector(networkActivityIndicatorVisible), @(networkActivityIndicatorVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)networkActivityIndicatorVisible {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
/** responseCacheType */
- (void)setResponseCacheType:(LATNetCacheType)responseCacheType {
    objc_setAssociatedObject(self, @selector(responseCacheType), @(responseCacheType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LATNetCacheType)responseCacheType {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @(LATNetCacheTypeMemoryAndDisk), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
/** requestCachePolicy */
- (void)setRequestCachePolicy:(NSURLRequestCachePolicy)requestCachePolicy {
    objc_setAssociatedObject(self, @selector(requestCachePolicy), @(requestCachePolicy), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSURLRequestCachePolicy)requestCachePolicy {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @(NSURLRequestUseProtocolCachePolicy), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
/** 请求头 */
- (void)setHTTPHeaderFields:(NSDictionary *)HTTPHeaderFields {
    objc_setAssociatedObject(self, @selector(HTTPHeaderFields), HTTPHeaderFields, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary *)HTTPHeaderFields {
    NSDictionary *headerFields = objc_getAssociatedObject(self, _cmd);
    if (!headerFields) {
        return ![UIApplication sharedApplication].LATNetSetHTTPHeaderFieldsBlock ? nil : [UIApplication sharedApplication].LATNetSetHTTPHeaderFieldsBlock();    }
    return headerFields;
}
- (NSString *)requestURLString {
    NSString *requestURLString = objc_getAssociatedObject(self, _cmd);
    if (!requestURLString) {
        /** Domain */
        NSString *domain = LATDomainDic[self.requestDomainType].stringDomain;
        /** 解决用户传入一个完整的链接，而不是一个合法的域名的问题 */
        NSURL *rootURL   = [NSURL URLWithString:@"/" relativeToURL:[NSURL URLWithString:domain]];
        NSString *domainString = [NSString stringWithFormat:@"%@",rootURL.absoluteString];
        
        /** ServerName */
            requestURLString = [NSString stringWithFormat:@"%@%@",domainString,LATServerNameDic[self.requestServerNameType].serverName];
        objc_setAssociatedObject(self, _cmd, requestURLString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return requestURLString;
    
}
- (NSDictionary *)requestParameters {
    NSDictionary *parameters = [self propertyStringDictionary];
    if ([UIApplication sharedApplication].LATRequestParametersFormatBlock) {
        parameters = [UIApplication sharedApplication].LATRequestParametersFormatBlock(parameters);
    }
    return parameters;
}
/** requestResultBlock */
- (void)setLATRequestResultBlock:(void (^)(id _Nullable, id _Nullable, LATNetError * _Nullable))LATRequestResultBlock {
    objc_setAssociatedObject(self, @selector(LATRequestResultBlock), LATRequestResultBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(id _Nonnull, id _Nonnull, LATNetError * _Nonnull))LATRequestResultBlock {
    return objc_getAssociatedObject(self, _cmd);
}
/** requestProgressBlock */
- (void)setLATRequestProgressBlock:(void (^)(NSProgress * _Nullable))LATRequestProgressBlock {
    objc_setAssociatedObject( self, @selector(LATRequestProgressBlock), LATRequestProgressBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(NSProgress * _Nullable))LATRequestProgressBlock {
    return objc_getAssociatedObject(self, _cmd);
}
/** ProgressBlock */
- (void)setResponseClass:(Class)responseClass {
    objc_setAssociatedObject(self, @selector(responseClass), responseClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (Class)responseClass {
    return objc_getAssociatedObject(self, _cmd);
}
@end
