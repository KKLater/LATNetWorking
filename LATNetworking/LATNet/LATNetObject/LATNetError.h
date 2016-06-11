//
//  LATNetError.h
//  LATNetworking
//
//  Created by Later on 16/2/25.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LATNetError : NSObject
@property (nonatomic, retain) NSString *entityName;                             /* 响应实体的名字 */
@property (nonatomic, retain, setter = description_:) NSString *description;    /* 响应描述 */
@property (nonatomic, assign) NSInteger code;                                   /* 响应码 */
@property (nonatomic, retain) NSError *detail;                                  /* 响应 错误描述 */
@property (nonatomic, retain) id fileBody;                                      /* 响应体 */
/**
 *
 *  创建error体
 *
 *  @param code   错误码
 *  @param desc   错误描述
 *  @param detail 真实错误信息
 *
 *  @return 错误体
 */
+ (LATNetError *)netErrorWithCode:(NSInteger)code desc:(NSString*)desc detailErr:(NSError *)detail;
@end