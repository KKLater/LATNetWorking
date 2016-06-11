//
//  LATFileManager.h
//  LATNetWorkingDemo
//
//  Created by Later on 16/1/2.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LATFileStoreType) {
    LATFileStoreTypeNone,
    LATFileStoreTypeDisk,
    LATFileStoreTypeMemory
};
@interface LATFileManager : NSObject
@property (assign, nonatomic) NSUInteger maxMemoryCost;
@property (assign, nonatomic) NSUInteger maxMemoryCount;
@property (assign, nonatomic) NSInteger  maxCacheInterval;
@property (assign, nonatomic) NSUInteger maxCacheSize;

#pragma mark 初始化
+ (LATFileManager *)defaultManager;
- (instancetype)initWithPathName:(NSString *)pathName;
- (id)initWithPathName:(NSString *)pathName directory:(NSString *)directory;

#pragma mark 存
- (void)setValue:(NSData *)file forKey:(NSString *)key;
- (void)setValue:(NSData *)file forKey:(NSString *)key  toDisk:(BOOL)toDisk;

- (void)setString:(NSString *)string forKey:(NSString *)key;
- (void)setString:(NSString *)string forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (void)setArray:(NSArray *)array forKey:(NSString *)key;
- (void)setArray:(NSArray *)array forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;
- (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (void)setObject:(NSObject<NSCoding> *)object forKey:(NSString *)key;
- (void)setObject:(NSObject<NSCoding> *)object forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (void)setImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;

#pragma mark 取
- (NSData *)valueFromMemoryForKey:(NSString *)key;
- (NSData *)valueFromDiskForKey:(NSString *)key;

- (NSString *)stringFromMemoryForKey:(NSString *)key;
- (NSString *)stringFromDiskForKey:(NSString *)key;

- (NSDictionary *)dictionaryFromMemoryForKey:(NSString *)key;
- (NSDictionary *)dictionaryFromDiskForKey:(NSString *)key;

- (NSArray *)arrayFromMemoryForKey:(NSString *)key;
- (NSArray *)arrayFromDiskForKey:(NSString *)key;

- (NSObject<NSCoding> *)objectFromMemoryForKey:(NSString *)key;
- (NSObject<NSCoding> *)objectFromDiskForKey:(NSString *)key;

- (UIImage *)imageFromMemoryForKey:(NSString *)key;
- (UIImage *)imageFromeDiskForKey:(NSString *)key;

- (NSOperation *)queryDiskDataForKey:(NSString *)key block:(void(^)(id value, LATFileStoreType type))block;

#pragma mark 删
- (void)removeValueForKey:(NSString *)key;
- (void)removeValueForKey:(NSString *)key completion:(void(^)())completion;
- (void)removeValueForKey:(NSString *)key fromDisk:(BOOL)fromDisk;
- (void)removeValueForKey:(NSString *)key fromDisk:(BOOL)fromDisk completion:(void(^)())completion;

- (void)clearMemory;

- (void)clearDiskCompletion:(void(^)())completion;
- (void)clearDisk;
- (void)cleanDiskCompletion:(void(^)())completion;
- (void)cleanDisk;

#pragma mark 查
- (void)diskValueExistsForKey:(NSString *)key completion:(void(^)(BOOL isExists))completion;
- (BOOL)diskValueExistsWithKey:(NSString *)key;

#pragma mark 数据
- (NSUInteger)getDiskSize;
- (NSUInteger)getDiskCount;
- (void)allSizeCompletionBlock:(void(^)(NSUInteger fileCount, NSUInteger totalSize))completionBlock;

#pragma mark 路径
- (NSString *)filePathForKey:(NSString *)key inPath:(NSString *)path;
- (NSString *)defaultFilePathForKey:(NSString *)key;
- (void)addReadOnlyCachePath:(NSString *)path;
- (NSString *)fileNameForKey:(NSString *)key;

- (NSString *)homePath;
- (NSString *)libraryPath;
- (NSString *)cachePath;
- (NSString *)documentPath;
- (NSString *)downloadPath;
- (NSString *)tempPath;
- (NSString *)homePath:(NSString *)pathName;
- (NSString *)libraryPath:(NSString *)pathName;
- (NSString *)cachePath:(NSString *)pathName;
- (NSString *)documentPath:(NSString *)pathName;
- (NSString *)downloadPath:(NSString *)pathName;
- (NSString *)tempPath:(NSString *)pathName;

@end
