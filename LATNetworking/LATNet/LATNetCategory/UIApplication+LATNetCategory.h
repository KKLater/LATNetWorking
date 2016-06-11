//
//  UIApplication+LATNetCategory.h
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (LATNetCategory)
/**
 *
 *  数据请求结束获取的json进行格式处理
 */
@property (copy, nonatomic) NSDictionary *(^LATRequestParametersFormatBlock)(NSDictionary *requestParameters);
/**
 *
 *  HTTPHeaderFields设置
 */
@property (copy, nonatomic) NSDictionary *(^LATNetSetHTTPHeaderFieldsBlock)();
@end
