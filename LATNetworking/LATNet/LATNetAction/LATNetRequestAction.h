//
//  LATNetBLLManager.h
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/3/18.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LATNetRequestAction : NSObject
/**
 *
 *  单例
 *
 *  @return 单利的RequestAction
 */
+ (nullable LATNetRequestAction *)shareAction;
/*!
 *
 *  根据数据请求体发起一个数据请求
 *
 *  @param netBLL 数据请求体
 */
+ (void)startRequest:(NSObject *)request;
/*!
 *
 *  根据请求体删除一个数据请求
 *
 *  @param netBLL 数据请求体
 */
+ (void)cancelRequest:(NSObject *)request;

@end
NS_ASSUME_NONNULL_END