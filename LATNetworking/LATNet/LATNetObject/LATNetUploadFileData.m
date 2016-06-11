//
//  LATNetUploadFileData.m
//  LATNetworking
//
//  Created by Later on 16/2/29.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "LATNetUploadFileData.h"

@implementation LATNetUploadFileData
- (instancetype)initWithName:(NSString *)name fileName:(NSString *)fileName data:(NSData *)data fileType:(NSString *)type {
    if (self = [super init]) {
        self.name = name ?: @"";
        self.fileName = fileName ?: @"";
        self.data = data ?: nil;
        self.fileType = type ?: @"";
    }
    return self;
}
@end
