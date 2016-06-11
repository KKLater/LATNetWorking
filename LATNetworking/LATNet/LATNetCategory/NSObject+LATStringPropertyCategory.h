//
//  NSObject+LATStringPropertyCategory.h
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/4/7.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LATStringPropertyCategory)
/**
 *
 *  对象属性生成的keyValue
 *
 *  @return 属性：值 = key：Value
 */
- (NSDictionary *)propertyStringDictionary;
/**
 *
 *  对象转字符串数组
 *
 *  @return 数组
 */
- (NSArray *)propertyStringArray;
/**
 *
 *  属性转为字符串
 *
 *  @param dic dic
 *
 *  @return 
 */
- (NSString*)propertyStringWithPropertyDic:(NSDictionary *)dic;
@end
