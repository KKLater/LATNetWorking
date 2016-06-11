
//
//  LATNetRequestEnitity.m
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "LATNetRequestEnitity.h"
#import "LATNetRequestAction.h"
#import "NSObject+LATNetMJExtensionCategory.h"
#import "NSObject+LATStringPropertyCategory.h"

@interface LATNetRequestEnitity ()
@property (nonatomic, copy, readwrite) NSString *requestURLString;
@property (nonatomic, copy, readwrite) NSDictionary *requestParameters;
@end
@implementation LATNetRequestEnitity
- (instancetype)init {
    if (self = [super init]) {
        self.requestMethodType = LATNetRequestMethodTypePOST;
        self.requestTimeoutInterval = 60;
        self.networkActivityIndicatorVisible = YES;
        self.responseCacheType = LATNetCacheTypeMemoryAndDisk;
        self.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return self;
}
- (void)startRequest {
    [LATNetRequestAction startRequest:self];
}
- (void)cancelRequest {
    [LATNetRequestAction cancelRequest:self];
}
- (void)setRequestDomainType:(LATNetDomainType)domainType serverName:(NSString *)serverName {
    self.requestDomainType = domainType;
    self.requestServerName = serverName;
}

- (NSString*)_lat_dictionaryToJson:(NSDictionary *)dic{
    if (dic && [NSJSONSerialization isValidJSONObject:dic]) {
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        if ([JSONData length] > 0) {
            NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
            return JSONString;
        }
    }
    return @"";
}
#pragma mark setter/getter
- (NSString *)requestURLString {
    if (!_requestURLString) {
        /** Domain */
        NSString *domain = LATDomainDic[self.requestDomainType].stringDomain;
        /** 解决用户传入一个完整的链接，而不是一个合法的域名的问题 */
        NSURL *rootURL = [NSURL URLWithString:@"/" relativeToURL:[NSURL URLWithString:domain]];
        NSString *domainString = [NSString stringWithFormat:@"%@",rootURL.absoluteString];
        
        /** ServerName */
        if (!self.requestServerName) {
            _requestURLString = domainString;
        } else {
            _requestURLString = [NSString stringWithFormat:@"%@%@",domainString,self.requestServerName];
        }
    }
    return _requestURLString;
    
}

- (NSDictionary *)requestParameters {
    NSDictionary *parameters = [self propertyStringDictionary];
    if ([UIApplication sharedApplication].LATRequestParametersFormatBlock) {
        parameters = [UIApplication sharedApplication].LATRequestParametersFormatBlock(parameters);
    }
    return parameters;
}
- (NSDictionary *)HTTPHeaderFields {
    if (!_HTTPHeaderFields) {
        return ![UIApplication sharedApplication].LATNetSetHTTPHeaderFieldsBlock ? nil : [UIApplication sharedApplication].LATNetSetHTTPHeaderFieldsBlock();
    }
    return _HTTPHeaderFields;
}

@end
