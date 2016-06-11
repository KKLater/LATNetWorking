//
//  NSObject+LATStringPropertyCategory.m
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/4/7.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "NSObject+LATStringPropertyCategory.h"
#import "LATNetWorking.h"

#import <objc/runtime.h>
@implementation NSObject (LATStringPropertyCategory)
/** 获取当前对象的属性集合 *//*(全部转字符串了)*/
- (NSDictionary *)propertyStringDictionary
{
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(object_getClass(self), &propertyCount);
    for(int i = 0 ; i < propertyCount ; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id propertyValue = [self valueForKey:propertyName];
        if (!propertyValue) {
            [dictionary setValue:@"" forKey:propertyName];
           } else {
            NSBundle *mainB = [NSBundle bundleForClass:[propertyValue class]];
            if (mainB == [NSBundle mainBundle]) {
                
                /** 自定义类 */
                
                NSDictionary *dic = [propertyValue propertyStringDictionary];
                [dictionary setValue:dic forKey:propertyName];
                
            } else {
                
                /** 非自定义类 */
                if ([propertyValue isKindOfClass:[NSObject class]]) {
                    
                    /** 是NSObject对象 */
                    if ([propertyValue isKindOfClass:[NSDictionary class]]) {
                        
                        /** 字典 */
                        NSDictionary *dic = [propertyValue propertyStringDictionary];
                        [dictionary setValue:dic  forKey:propertyName];
                    } else if([propertyValue isKindOfClass:[NSArray class]]) {
                        
                        /** 数组 */
                        NSArray *arr = [propertyValue propertyStringArray];
                        [dictionary setValue:arr  forKey:propertyName];
                    } else {
                        
                        /** 其他 */
                        [dictionary setValue:[propertyValue description] ?: @"" forKey:propertyName];
                    }
                    
                } else {
                    
                    /** 非NSObject对象 */
                    LAT_Net_Log(@"%@类的%@属性不符合要求规定，为非对象属性参数",[self class], propertyName);
                    [dictionary setValue:@"" forKey:propertyName];
                }
            }
            
        }
    }
    free(properties);
    return dictionary;
}

- (NSArray *)propertyStringArray
{
    NSMutableArray *propertyArray = [@[] mutableCopy];
    if ([self isKindOfClass:[NSArray class]]) {
        for (id obj in (NSArray *)self) {
            
            NSBundle *mainB = [NSBundle bundleForClass:[obj class]];
            if (mainB == [NSBundle mainBundle]) {
                
                /** 自定义类 */
                NSDictionary *dic = [obj propertyStringDictionary];
                [propertyArray addObject:dic];
                
            } else {
                
                /** 非自定义类 */
                if ([obj isKindOfClass:[NSObject class]]) {
                    
                    /** 是NSObject对象 */
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        /** 字典 */
                        NSDictionary *dic = [obj propertyStringDictionary];
                        [propertyArray addObject:dic];
                    } else if([obj isKindOfClass:[NSArray class]]) {
                        
                        /** 数组 */
                        NSArray *arr = [obj propertyStringArray];
                        [propertyArray addObject:arr];
                    } else {
                        
                        /** 其他 */
                        [propertyArray addObject:[obj description] ?: @""];
                    }
                    
                } else {
                    
                    /** 非NSObject对象 */
                    LAT_Net_Log(@"%@类的%@属性不符合要求规定，为非对象属性参数",[self class], obj);
                }
            }
        }
    }
    return propertyArray;
}
- (NSString*)propertyStringWithPropertyDic:(NSDictionary *)dic {
    if (dic && [NSJSONSerialization isValidJSONObject:dic]) {
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        if ([JSONData length] > 0) {
            NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
            return JSONString;
        }
    }
    return @"";
}
@end
