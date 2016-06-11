//
//  LATNetUploadFileData.h
//  LATNetworking
//
//  Created by Later on 16/2/29.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LATNetUploadFileData : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * fileName;
@property (nonatomic, strong) NSData * data;
@property (nonatomic, copy) NSString * fileType;
/**
 *  生成一个上传文件体
 *
 *  @param name     上传的数据的name
 *  @param fileName 上传的文件的文件名
 *  @param data     上传数据的data
 *  @param type     上传文件类型
 *
 */
- (instancetype)initWithName:(NSString *)name fileName:(NSString *)fileName data:(NSData *)data fileType:(NSString *)type;
@end
