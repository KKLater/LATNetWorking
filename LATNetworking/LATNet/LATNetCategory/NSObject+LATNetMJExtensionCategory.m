//
//  NSDictionary+LATNetMJExtensionCategory.m
//  LATNetworking
//
//  Created by Later on 16/4/7.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "NSObject+LATNetMJExtensionCategory.h"
#import "MJExtension.h"

@implementation NSObject (LATNetMJExtensionCategory)
+ (id<NSObject>)responseObjectWithResponse:(id)response {
    id<NSObject> respondObject = nil;
    if (response && [NSJSONSerialization isValidJSONObject:response]) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            /** 字典处理 */
            respondObject = [self mj_objectWithKeyValues:response];
            return respondObject;
        } else if([response isKindOfClass:[NSArray class]]) {
            /** 数组实现 */
            respondObject = [self mj_objectArrayWithKeyValuesArray:response];
            return respondObject;
        }
    }
    return nil;
}
@end
