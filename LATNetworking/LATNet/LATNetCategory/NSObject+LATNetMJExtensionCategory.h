//
//  NSDictionary+LATNetMJExtensionCategory.h
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/4/7.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LATNetMJExtensionCategory)
/**
 *  实例化响应
 *
 *  @param response  相应数据
 *
 *  @return 响应对象
 */
+ (id<NSObject>)responseObjectWithResponse:(id)response;
@end
