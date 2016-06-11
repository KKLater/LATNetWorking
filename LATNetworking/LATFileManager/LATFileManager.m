//
//  LATFileManager.m
//  LATNetWorkingDemo
//
//  Created by Later on 16/1/2.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "LATFileManager.h"
#import "LATNetWorking.h"
#import <CommonCrypto/CommonDigest.h>
#define LAT_FileManager [[LATFileManager alloc]init]

@interface LATAutoPurgeCache : NSCache
@end

@implementation LATAutoPurgeCache

- (instancetype)init{
    if (self = [super init]) {
        /** 添加之前删除所有的观察者 */
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidReceiveMemoryWarningNotification
                                                      object:nil];
        /** 添加观察者 */
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeAllObjects)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc{
    /** 最后释放的时候要移除观察者 */
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidReceiveMemoryWarningNotification
                                                  object:nil];
}

@end

static NSString *const kLATFileManagerName           = @"com.LATFileManager.";
static const char* kLATFileManagerQueue              = "com.Queue.LATFileManager";
static const NSInteger kDefaultDiskCacheMaxCacheInterval = 60 * 60 * 24 * 7; // 1 周

@interface LATFileManager (){
    NSFileManager * fileManager;
}
/** 自动清除的内存 */
@property (strong, nonatomic) LATAutoPurgeCache *memoryCache;
/** 文件路径，初始化生成 */
@property (strong, nonatomic) NSString *filePath;
/** 所有路径，addReadOnlyPath */
@property (strong, nonatomic) NSMutableArray *customPaths;
/** 文件管理使用的线程 */
@property (nonatomic) dispatch_queue_t fileManagerQueue;
@end

@implementation LATFileManager
+ (LATFileManager *)defaultManager {
    static dispatch_once_t once;
    static LATFileManager * manager;
    dispatch_once(&once, ^{ manager = LATFileManager.new; });
    return manager;
}
- (id)init {
    return [self initWithPathName:@"Default"];
}
- (instancetype)initWithPathName:(NSString *)pathName{
    NSString *path = [self cachePath:pathName];
    return [self initWithPathName:pathName directory:path];
}
- (instancetype)initWithPathName:(NSString *)pathName directory:(NSString *)directory{
    if (self = [super init]) {
        NSString *fullNamespace = [kLATFileManagerName stringByAppendingString:pathName];
        _fileManagerQueue = dispatch_queue_create(kLATFileManagerQueue, DISPATCH_QUEUE_SERIAL);
        _maxCacheInterval = kDefaultDiskCacheMaxCacheInterval;
        _memoryCache = [[LATAutoPurgeCache alloc] init];
        _memoryCache.name = fullNamespace;
        if (directory != nil) {
            _filePath = [directory stringByAppendingPathComponent:fullNamespace];
        } else {
            NSString *path = [self cachePath:pathName];
            _filePath = path;
        }
        dispatch_sync(_fileManagerQueue, ^{ fileManager = NSFileManager.new; });
#if TARGET_OS_IPHONE
        [self _lat_addNotificationObserver];
#endif
    }
    return self;
}

#pragma mark 存
- (void)setValue:(NSData *)file forKey:(NSString *)key{
    [self setValue:file forKey:key toDisk:YES];
}
- (void)setValue:(NSData *)file forKey:(NSString *)key  toDisk:(BOOL)toDisk{
    if (!file || !key)
        return;
    /** 存内存 */
    [self.memoryCache setObject:file forKey:key];
    
    if (toDisk) {
        /** 写入磁盘 */
        dispatch_async(self.fileManagerQueue, ^{
            if (![fileManager fileExistsAtPath:self.filePath])
                [fileManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:NULL];
            [fileManager createFileAtPath:[self defaultFilePathForKey:key] contents:file attributes:nil];
        });
    }
}


- (void)setString:(NSString *)string forKey:(NSString *)key{
    [self setString:string forKey:key toDisk:YES];
}
- (void)setString:(NSString *)string forKey:(NSString *)key toDisk:(BOOL)toDisk{
    if (!string || !key) return;
    [self.memoryCache setObject:string forKey:key];
    if (toDisk) {
        dispatch_async(self.fileManagerQueue, ^{
            if (![fileManager fileExistsAtPath:self.filePath])
                [fileManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:NULL];
            [string writeToFile:[self defaultFilePathForKey:key] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        });
    }
}

- (void)setArray:(NSArray *)array forKey:(NSString *)key{
    [self setArray:array forKey:key toDisk:YES];
}
- (void)setArray:(NSArray *)array forKey:(NSString *)key toDisk:(BOOL)toDisk{
    if (!array || !key) return;
    [self.memoryCache setObject:array forKey:key];
    if (toDisk) {
        dispatch_async(self.fileManagerQueue, ^{
            if (![fileManager fileExistsAtPath:self.filePath])
                [fileManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:NULL];
            [array writeToFile:[self defaultFilePathForKey:key] atomically:YES];
        });
    }
}

- (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key{
    [self setDictionary:dictionary forKey:key toDisk:YES];
}
- (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key toDisk:(BOOL)toDisk{
    if (!dictionary || !key) return;
    [self.memoryCache setObject:dictionary forKey:key];
    if (toDisk) {
        dispatch_async(self.fileManagerQueue, ^{
            if (![fileManager fileExistsAtPath:self.filePath])
                [fileManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:NULL];
            [dictionary writeToFile:[self defaultFilePathForKey:key] atomically:YES];
        });
    }
}

- (void)setObject:(NSObject<NSCoding> *)object forKey:(NSString *)key{
    [self setObject:object forKey:key toDisk:YES];
}
- (void)setObject:(NSObject<NSCoding> *)object forKey:(NSString *)key toDisk:(BOOL)toDisk{
    if (!object || !key) return;
    [self.memoryCache setObject:object forKey:key];
    if (toDisk) {
        dispatch_async(self.fileManagerQueue, ^{
            if (![fileManager fileExistsAtPath:self.filePath])
                [fileManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:NULL];
            
            LAT_Net_Log(@"%@", [self defaultFilePathForKey:key]);
            [fileManager createFileAtPath:[self defaultFilePathForKey:key] contents:[NSKeyedArchiver archivedDataWithRootObject:object] attributes:nil];
            
            
        });
    }
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key{
    [self setImage:image forKey:key toDisk:YES];
}
- (void)setImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk{
    [self setObject:image forKey:key toDisk:toDisk];
}


#pragma mark 取
- (NSData *)valueFromMemoryForKey:(NSString *)key{
    return [self.memoryCache objectForKey:key];
}
- (NSData *)valueFromDiskForKey:(NSString *)key{
    /** 取内存 */
    NSData *data = [self valueFromMemoryForKey:key];
    if (data)
        return data;
    
    /** 取磁盘 */
    return [self _lat_diskDataBySearchingAllPathsForKey:key];
}
- (NSData *)_lat_diskDataBySearchingAllPathsForKey:(NSString *)key{
    /** 找Default */
    NSString *defaultPath = [self defaultFilePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data)
        return data;
    
    /** 找所有文件 */
    NSArray *customPaths = [self.customPaths copy];
    for (NSString *path in customPaths) {
        NSString *filePath = [self filePathForKey:key inPath:path];
        NSData *data= [NSData dataWithContentsOfFile:filePath];
        if (data)
            return data;
    }
    return nil;
}

- (NSString *)stringFromMemoryForKey:(NSString *)key{
    return [self.memoryCache objectForKey:key];
}
- (NSString *)stringFromDiskForKey:(NSString *)key{
    NSString *string = [self stringFromMemoryForKey:key];
    if (string) return string;
    
    return [self _lat_diskStringBySearchingAllPathsForKey:key];
}
- (NSString *)_lat_diskStringBySearchingAllPathsForKey:(NSString *)key{
    /** 找Default */
    NSString *defaultPath = [self defaultFilePathForKey:key];
    NSString *string = [NSString stringWithContentsOfFile:defaultPath encoding:NSUTF8StringEncoding error:nil];
    if (string)
        return string;
    
    /** 找所有文件 */
    NSArray *customPaths = [self.customPaths copy];
    for (NSString *path in customPaths) {
        NSString *filePath = [self filePathForKey:key inPath:path];
        NSString *string= [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (string)
            return string;
    }
    return nil;
    
}
- (NSDictionary *)dictionaryFromMemoryForKey:(NSString *)key{
    return [self.memoryCache objectForKey:key];
}
- (NSDictionary *)dictionaryFromDiskForKey:(NSString *)key{
    NSDictionary * dictionary = [self dictionaryFromMemoryForKey:key];
    if (dictionary) return dictionary;
    
    return [self _lat_diskDictionaryBySearchingAllPathsForKey:key];
    
}
- (NSDictionary *)_lat_diskDictionaryBySearchingAllPathsForKey:(NSString *)key{
    /** 找Default */
    NSString *defaultPath = [self defaultFilePathForKey:key];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:defaultPath];
    if (dictionary)
        return dictionary;
    
    /** 找所有文件 */
    NSArray *customPaths = [self.customPaths copy];
    for (NSString *path in customPaths) {
        NSString *filePath = [self filePathForKey:key inPath:path];
        NSDictionary *dictionary= [NSDictionary dictionaryWithContentsOfFile:filePath];
        if (dictionary)
            return dictionary;
    }
    return nil;
    
}
- (NSArray *)arrayFromMemoryForKey:(NSString *)key{
    return [self.memoryCache objectForKey:key];
}
- (NSArray *)arrayFromDiskForKey:(NSString *)key{
    NSArray *array = [self arrayFromMemoryForKey:key];
    if (array) return array;
    
    return [self _lat_diskArrayBySearchingAllPathsForKey:key];
}
- (NSArray *)_lat_diskArrayBySearchingAllPathsForKey:(NSString *)key{
    /** 找Default */
    NSString *defaultPath = [self defaultFilePathForKey:key];
    NSArray *array = [NSArray arrayWithContentsOfFile:defaultPath];
    if (array)
        return array;
    
    /** 找所有文件 */
    NSArray *customPaths = [self.customPaths copy];
    for (NSString *path in customPaths) {
        NSString *filePath = [self filePathForKey:key inPath:path];
        NSArray *array= [NSArray arrayWithContentsOfFile:filePath];
        if (array)
            return array;
    }
    return nil;
}
- (NSObject<NSCoding> *)objectFromMemoryForKey:(NSString *)key{
    return [self.memoryCache objectForKey:key];
}
- (NSObject<NSCoding> *)objectFromDiskForKey:(NSString *)key{
    NSObject *object = [self objectFromMemoryForKey:key];
    if (object) return (NSObject<NSCoding> *)object;
    
    /** 找Default */
    NSString *defaultPath = [self defaultFilePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (obj)
        return obj;
    
    NSArray *customPaths = [self.customPaths copy];
    for (NSString *path in customPaths) {
        NSString *filePath = [self filePathForKey:key inPath:path];
        LAT_Net_Log(@"%@", filePath);
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (data) {
            NSObject<NSCoding> *object= [NSKeyedUnarchiver unarchiveObjectWithData:data];
            return object;
        }
    }
    return nil;
}
- (UIImage *)imageFromMemoryForKey:(NSString *)key{
    return [self.memoryCache objectForKey:key];
}
- (UIImage *)imageFromeDiskForKey:(NSString *)key{
    UIImage *image = (UIImage *)[self objectFromDiskForKey:key];
    return image;
}
- (NSOperation *)queryDiskDataForKey:(NSString *)key block:(void(^)(id data, LATFileStoreType type))block{
    if (!block) return nil;
    if (!key) {
        block(nil, LATFileStoreTypeNone);
        return nil;
    }
    NSData *data = [self valueFromMemoryForKey:key];
    if (data) {
        block(data, LATFileStoreTypeMemory);
        return nil;
    }
    NSOperation *operation = [NSOperation new];
    dispatch_async(self.fileManagerQueue, ^{
        if (operation.isCancelled)
            return;
        @autoreleasepool {
            NSData *data = [self valueFromDiskForKey:key];
            if (data)
                [self.memoryCache setObject:data forKey:key];
            dispatch_async(dispatch_get_main_queue(), ^{ block(data, LATFileStoreTypeDisk); });
        }
    });
    return operation;
}
#pragma mark 删
- (void)removeValueForKey:(NSString *)key{
    [self removeValueForKey:key completion:nil];
}
- (void)removeValueForKey:(NSString *)key completion:(void(^)())completion{
    [self removeValueForKey:key fromDisk:YES completion:completion];
}
- (void)removeValueForKey:(NSString *)key fromDisk:(BOOL)fromDisk{
    [self removeValueForKey:key fromDisk:fromDisk completion:nil];
}
- (void)removeValueForKey:(NSString *)key fromDisk:(BOOL)fromDisk completion:(void(^)())completion{
    if (!key)
        return;
    /** 内存移除 */
    [self.memoryCache removeObjectForKey:key];
    
    if (fromDisk) {
        /** 磁盘移除 */
        dispatch_async(self.fileManagerQueue, ^{
            [fileManager removeItemAtPath:[self defaultFilePathForKey:key] error:nil];
            if (completion)
                dispatch_async(dispatch_get_main_queue(), ^{ completion(); });
        });
    } else if (completion){ completion(); }
}

#pragma mark 清理
- (void)clearMemory{
    [self.memoryCache removeAllObjects];
}

- (void)clearDiskCompletion:(void(^)())completion{
    dispatch_async(self.fileManagerQueue, ^{
        [fileManager removeItemAtPath:self.filePath error:nil];
        [fileManager createDirectoryAtPath:self.filePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        if (completion)
            dispatch_async(dispatch_get_main_queue(), ^{ completion(); });
        
    });
    
}
- (void)clearDisk{
    [self clearDiskCompletion:nil];
}
- (void)cleanDiskCompletion:(void(^)())completion{
    dispatch_async(self.fileManagerQueue, ^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:self.filePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey,
                                  NSURLContentModificationDateKey,
                                  NSURLTotalFileAllocatedSizeKey];
        
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtURL:diskCacheURL
                                                  includingPropertiesForKeys:resourceKeys
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheInterval];
        NSMutableDictionary *files = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            /** 跳过的部分 */
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) { continue; }
            
            /** 移除日期已经过期文件 */
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [files setObject:resourceValues forKey:fileURL];
        }
        
        for (NSURL *fileURL in urlsToDelete)
            [fileManager removeItemAtURL:fileURL error:nil];
        
        
        /** 移除过大 */
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            
            NSArray *sortedFiles = [files keysSortedByValueWithOptions:NSSortConcurrent
                                    
                                                       usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                           return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                       }];
            
            for (NSURL *fileURL in sortedFiles) {
                if ([fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = files[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    if (currentCacheSize < desiredCacheSize) break;
                }
            }
        }
        if (completion)
            dispatch_async(dispatch_get_main_queue(), ^{ completion(); });
    });
    
}
- (void)cleanDisk{
    [self cleanDiskCompletion:nil];
}

- (void)cleanDickBackground {
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) return;
    
    UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    [self cleanDiskCompletion:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

#pragma mark 查
- (void)diskValueExistsForKey:(NSString *)key completion:(void(^)(BOOL isExists))completion{
    dispatch_async(self.fileManagerQueue, ^{
        BOOL exists = [fileManager fileExistsAtPath:[self defaultFilePathForKey:key]];
        if (completion)
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(exists);
            });
    });
}
- (BOOL)diskValueExistsWithKey:(NSString *)key{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self defaultFilePathForKey:key]];
}

#pragma mark 路径
- (NSString *)homePath{
    return NSHomeDirectory();
}
- (NSString *)libraryPath{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
}
- (NSString *)cachePath{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}
- (NSString *)documentPath{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}
- (NSString *)downloadPath{
    return NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES).lastObject;
}
- (NSString *)tempPath{
    return NSTemporaryDirectory();
}
- (NSString *)homePath:(NSString *)pathName{
    return [[self homePath] stringByAppendingPathComponent:pathName];
}
- (NSString *)libraryPath:(NSString *)pathName{
    return [[self libraryPath] stringByAppendingPathComponent:pathName];
}
- (NSString *)cachePath:(NSString *)pathName{
    return [[self cachePath] stringByAppendingPathComponent:pathName];
}
- (NSString *)documentPath:(NSString *)pathName{
    return [[self documentPath] stringByAppendingPathComponent:pathName];
}
- (NSString *)downloadPath:(NSString *)pathName{
    return [[self downloadPath] stringByAppendingPathComponent:pathName];
}
- (NSString *)tempPath:(NSString *)pathName{
    return [[self tempPath] stringByAppendingPathComponent:pathName];
}
- (NSString *)filePathForKey:(NSString *)key inPath:(NSString *)path {
    NSString *filename = [self fileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}
- (NSString *)defaultFilePathForKey:(NSString *)key {
    return [self filePathForKey:key inPath:self.filePath];
}

- (void)addReadOnlyCachePath:(NSString *)path {
    if (!self.customPaths)
        self.customPaths = [NSMutableArray new];
    if (![self.customPaths containsObject:path])
        [self.customPaths addObject:path];
}

- (NSString *)fileNameForKey:(NSString *)key {
    const char *original_str = [key UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
#pragma mark 数据
- (NSUInteger)getDiskSize {
    __block NSUInteger size = 0;
    dispatch_sync(self.fileManagerQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:self.filePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.filePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)getDiskCount {
    __block NSUInteger count = 0;
    dispatch_sync(self.fileManagerQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:self.filePath];
        count = [[fileEnumerator allObjects] count];
    });
    return count;
}

- (void)allSizeCompletionBlock:(void(^)(NSUInteger fileCount, NSUInteger totalSize))completion{
    NSURL *diskCacheURL = [NSURL fileURLWithPath:self.filePath isDirectory:YES];
    
    dispatch_async(self.fileManagerQueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtURL:diskCacheURL
                                                  includingPropertiesForKeys:@[NSFileSize]
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (completion)
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(fileCount, totalSize);
            });
    });
}
#pragma mark 其他
- (void)dealloc {
    [self _lat_removeNotificationObserver];
}


- (void)_lat_addNotificationObserver{
    [self _lat_removeNotificationObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearMemory)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanDisk)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanDickBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}
- (void)_lat_removeNotificationObserver{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
}

@end