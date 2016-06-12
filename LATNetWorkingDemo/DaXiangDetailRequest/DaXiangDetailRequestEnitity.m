
//
//  DaXiangDetailRequestEnitity.m
//  LATNetWorkingDemo
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "DaXiangDetailRequestEnitity.h"

@implementation DaXiangDetailRequestEnitity
- (instancetype)init {
    if (self = [super init]) {
        self.requestDomainType = LATDomainTypeDaXiang;
        self.requestServerNameType = LATNetServerNameTypeDaXiangNewsDetailInfo;
        self.requestMethodType = LATNetRequestMethodTypeGET;
        
        /*
        //单独设置HTTPheaderFields
        NSMutableDictionary *headers = [NSMutableDictionary new];
        [headers setValue:@"ElephantSmartisan/2.1.0 (iPhone; iOS 9.3.2; Scale/2.00)" forKey:@"User-Agent"];
        [headers setValue:@"application/octet-stream" forKey:@"Content-Type"];
        [headers setValue:@"keep-alive" forKey:@"Connection"];
        [headers setValue:@"zh-Hans-CN;q=1, ar-CN;q=0.9, pl-PL;q=0.8, de-AT;q=0.7, fr-FR;q=0.6, ru-RU;q=0.5" forKey:@"Accept-Language"];
        [headers setValue:@"gzip, deflate" forKey:@"Accept-Encoding"];
        self.HTTPHeaderFields = headers;
         */
    }
    return self;
}
@end
