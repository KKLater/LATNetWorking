//
//  LATNetAFNRequest.h
//  https://github.com/KKLater/LATNetWorking.git
//
//  Created by Later on 16/4/7.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LATNetAFNRequestManager : NSObject
+ (LATNetAFNRequestManager *)sharedManager;
/**
 *
 *  发起数据请求
 *
 *  @param requestMethod     数据请求方式 “GET/POST/PUT/PATCH/DELETE/HEAD”
 *  @param requestURLString  数据请求url
 *  @param requestParameters 数据请求parameters
 *  @param success           数据请求成功
 *  @param failure           数据请求失败
 *
 *  @return 数据请求的dataTash
 */
- (NSURLSessionDataTask *)startRequestWithMethod:(NSString *)requestMethod
                                requestURLString:(NSString *)requestURLString
                               requestParameters:(nullable NSDictionary *)requestParameters
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/**
 *
 *  发起数据请求
 *
 *  @param requestMethod     数据请求方式 “GET/POST/HEAD/PUT/PATCH/DELETE”
 *  @param requestURLString  数据请求url
 *  @param requestParameters 数据请求parameters
 *  @param uploadProgress    数据请求进度
 *  @param success           数据请求成功
 *  @param failure           数据请求失败
 *
 *  @return 数据请求的dataTask
 */
- (NSURLSessionDataTask *)startRequestWithMethod:(NSString *)requestMethod
                                requestURLString:(NSString *)requestURLString
                               requestParameters:(nullable NSDictionary *)requestParameters
                                        progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/**
 *
 *  发起数据请求
 *
 *  @param requestMethod        数据请求方式 “GET/POST/HEAD/PUT/PATCH/DELETE”
 *  @param requestURLString     数据请求url
 *  @param requestParameters    数据请求poarameters
 *  @param requestPostFileDatas 数据请求发送的数据data
 *  @param cachePolicy          数据请求的NSURLRequestCachePolicy
 *  @param timeOutInterval      数据请求超时时间
 *  @param httpFields           数据请求的httpFields
 *  @param uploadProgress       数据请求进度
 *  @param success              数据请求成功
 *  @param failure              数据请求失败
 *
 *  @return 数据请求dataTask
 */
- (NSURLSessionDataTask *)startRequestWithMethod:(NSString *)requestMethod
                                requestURLString:(NSString *)requestURLString
                               requestParameters:(nullable NSDictionary *)requestParameters
                            requestPostFileDatas:(nullable NSArray *)requestPostFileDatas
                              requestCachePolicy:(NSURLRequestCachePolicy)cachePolicy
                                 timeOutInterval:(NSTimeInterval)timeOutInterval
                                      httpFields:(nullable NSDictionary *)httpFields
                                        progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
NS_ASSUME_NONNULL_END
