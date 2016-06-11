#LATNetworking	API介绍

[TOC]

## 【实现功能】

- 支持iOS7.0以上数据请求
- 实现分布式和集中式数据请求架构
- 'GET'/'POST'/'HEAD'/'PATCH'/'PUT'/'DELETE'请求


- 多文件上传（带进度）


- RequestEnitity -> Json数据提交


- Json -> ResponseEnitity数据响应


- LATFileManager缓存
- LATNetReachability网络状态判定


- Header配置

## 【使用方法】

###【包依赖】

* AFNetworking

* MJExtension

* Reachability


### 【分布式数据请求】

BLL -> 负责业务层与网络层数据的对接，数据流管道。携带有一个数据请求体，发起数据请求。如果有本地数据库的操作，也完成数据本地化。

RequestEnitity -> 数据请求体，配置数据请求参数，发起数据请求。

ResponseEnitity -> 数据请求响应体，数据请求成功后，仿射出来的对象。

#### 0.配置项

数据请求发起之前，需要做部分配置。

**配置1**：网络请求domain域名配置

```objective-c
/*!
 *
 *  网络请求的所有域名
 */
static const LATNetDomainDic LATDomainDic[] = {
    {@"http://app.idaxiang.org/"}      
};
/*!
 *
 *  网络请求组件类型type枚举
 */
typedef NS_ENUM(NSInteger, LATNetDomainType) {
    LATDomainTypeDaXiang      =   0      
};
```

LATDomainDic与LATNetDomainType查表一一对应，数据请求使用前，必配置项！

**配置2**：网络请求超时时间

```objective-c
#ifndef LAT_NET_OUTTIMEINTERVAL
#define LAT_NET_OUTTIMEINTERVAL 60
#endif
```

以宏定义配置的默认网络请求超时时间。此处只是配置默认值，对单个网络请求，在发起前仍可单独设置。

**配置3**：最大允许host

```objective-c
#ifndef LAT_MAX_HTTP_CONNECTION_PER_HOST
#define LAT_MAX_HTTP_CONNECTION_PER_HOST 5
#endif
```

**配置4**：version

```objective-c
#ifndef LAT_NET_VERSION
#define LAT_NET_VERSION @"1.0.0"
#endif
```



#### 1.如何设置接口参数

RequestEnitity继承与LATNetRequestEnitity，设置数据请求接口参数和协议参数

* 设置数据请求接口参数

  请求接口参数涉及到RequestDomain、severName等为必须设置项。其他为可选项设置。

  ```objective-c
  /**
   *
   *  网络请求的domainType类型，设置位于LATNetSetting.h中
   *  用于获取网络请求的域名
   *  域名获取原理：NSString *netDomain = LATDomainDic[LATDomainTypeDaXiang].stringDomain;
   */
  @property (nonatomic, assign) LATNetDomainType requestDomainType;
  /**
   *
   *  网络请求的severName
   */
  @property (nonatomic, copy) NSString *requestServerName;
  //id
  @property (copy, nonatomic) NSString *id;
  ```

* 设置协议参数

  协议参数包括网络请求类型、超时时间、HTTPHeaderFields等。均含有默认值，为可选设置类型。

  ```objective-c
  /**
   *
   *  网络请求方式'GET'/'POST'/'HEAD'/'PATCH'/'PUT'/'DELETE'
   *  默认：'LATNetRequestMethodTypyPOST' -> 'post'请求
   */
  @property (nonatomic, assign) LATNetRequestMethodType requestMethodType;
  /**
   *
   *  数据请求超时 -> 60s
   */
  @property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;
  ```

  HTTPHeaderFields设置有两种方式：

  * 集中设置：

    ```objective-c
        //对网络请求集中设置HTTPHeaderFields
        [[UIApplication sharedApplication] setLATNetSetHTTPHeaderFieldsBlock:^NSDictionary *{
            NSMutableDictionary *headers = [NSMutableDictionary new];
            [headers setValue:@"LATNetWorking/1.0.0 (iPhone; iOS 9.3.2; Scale/2.00)" forKey:@"User-Agent"];
            [headers setValue:@"application/octet-stream" forKey:@"Content-Type"];
            [headers setValue:@"keep-alive" forKey:@"Connection"];
            [headers setValue:@"zh-Hans-CN;q=1, ar-CN;q=0.9, pl-PL;q=0.8, de-AT;q=0.7, fr-FR;q=0.6, ru-RU;q=0.5" forKey:@"Accept-Language"];
            [headers setValue:@"gzip, deflate" forKey:@"Accept-Encoding"];
            return headers;
        }];

    ```

  * 独立设置

    ```objective-c
    //单独设置HTTPheaderFields
    NSMutableDictionary *headers = [NSMutableDictionary new];
    [headers setValue:@"ElephantSmartisan/2.1.0 (iPhone; iOS 9.3.2; Scale/2.00)" forKey:@"User-Agent"];
    [headers setValue:@"application/octet-stream" forKey:@"Content-Type"];
    [headers setValue:@"keep-alive" forKey:@"Connection"];
    [headers setValue:@"zh-Hans-CN;q=1, ar-CN;q=0.9, pl-PL;q=0.8, de-AT;q=0.7, fr-FR;q=0.6, ru-RU;q=0.5" forKey:@"Accept-Language"];
    [headers setValue:@"gzip, deflate" forKey:@"Accept-Encoding"];
    self.HTTPHeaderFields = headers;
    ```

    **单独设置优先原则**：在单独设置了HTTPHeaderFields的同时，集中设置了HTTPHeaderFields，则优先使用单独设置的。

* 设置ResponseClass项

  responseClass项关系到是否在数据请求成功后，抛出数据原型model。如果设置该项，则数据请求结束时，除了抛出数据请求原数据（一般是JSON），还抛出原型对象；如果没有设置该项，则只抛出数据请求结束时的请求原数据（一般是JSON）。抛出数据的同时，抛出错误信息类:LATNetError。

* 关于ResponseCacheType

  responseCacheType设置项影响到数据请求结果的缓存。

  该设置项是一个枚举类，分别如下：

  ```objective-c
  typedef NS_ENUM(NSInteger, LATNetCacheType) {
      LATNetCacheTypeMemoryAndDisk,   //内存+磁盘 （默认）
      LATNetCacheTypeMemory,          //内存
      LATNetCacheTypeNone             //不存储
  };
  ```

  设置存储策略不一样，则数据请求时返回数据逻辑不一样。

  * LATNetCacheTypeMemoryAndDisk/LATNetCacheTypeMemory：数据请求发起前，首先取本地缓存，并通过设置的数据请求成功block抛出缓存数据。同时，发起数据请求，获取网络数据。网络请求成功后，保存本地的同时，抛出数据。
  * LATNetCacheTypeNone：不抛出任何缓存，数据请求结束后，数据不做任何缓存。

#### 2.网络请求的发起、进度、结果、取消

* 网络请求的发起

  ```objective-c
  //由继承与LATNetRequestEnitity的网络请求体发起一个网络请求	
  [self.requestEnitity startRequest];
  ```

* 网络请求进度

  ```objective-c
  //设置网络请求进度的block来获取网络请求的数据进度
  /**
   *
   *  请求进度block
   */
  @property (nullable, nonatomic, copy) void(^LATRequestProgressBlock)(NSProgress * _Nullable progress);
  ```

* 网络请求结果

  网络请求结果对成功和失败进行了集中处理。

  responseData：数据请求的原始数据（一般是json）

  responseObject：requestEnitity发起请求前设置了ResponseClass时，对应的响应model。

  httpError：网络请求失败设置。

  ```objective-c
  /**
   *
   *  请求结果的block
   */
  @property (nullable, nonatomic, copy) void(^LATRequestResultBlock)(id _Nullable responseData,id _Nullable responseObject, LATNetError *_Nullable httpError);
  ```

* 网络请求的取消

  已经发起的网络请求是无法取消的，我们只能手动取消掉该网络对应的各部分响应，保证在请求结束时Api不作任何响应。

  ```objective-c
  /**
   *
   *  停止请求
   */
  - (void)cancelRequest;
  ```

  ​

#### 3.上传数据

上传数据的RequestEnitity需要配置`requestPostFileDatas`属性。

```objective-c
/**
 *  @author Later, 16-04-06 11:04
 *
 *  上传数据
 */
@property (nonatomic, strong) NSArray<LATNetUploadFileData *> *requestPostFileDatas;
```

在发起请求时，API会根据是否设置了该属性进行执行普通数据请求还是上传数据的数据请求。

### 【集中式网络请求】

相对于创建较多的类，有可能引起类爆炸的分布式网络请求，集中式网络请求要相对简单得多，同时，也容易得多。

集中式网络请求仍需要做配置项设置。除了分布式网络请求中的LATDomainDic与LATNetDomainType一一对应的表不需要设置外，其他三项仍需要配置。

发起网络请求方式相对较为简单，主要有以下方法参考：

```objective-c
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

```

集中式网络请求由`LATNetAFNRequestManager`的单利`sharedManager`发起，所以真正要完成一个集中式网络请求，需要调用`-(LATNetAFNRequestManager *)sharedManager;`完成单利的初始化，之后发起一个网络请求。

## 优缺点对比

* 分布式网络请求：
  * 每个网络请求都是一个对象，易于对单独网络进行设置的同时，便于后期维护整理。
  * 网络请求过程均面向对象，保证了数据的安全性，和使用者的易操作性。
  * 网络请求的接口集中在Domain\DomainType查表管理，便于整理接口的维护更新。
* 集中式网络请求：
  * 网络请求使用NSString、NSDictionary等基础数据类，没有代码偶合。然而，增加了业务要求精度。
  * 网络请求不易于单独设置管理。
  * 网络请求直接使用URL等配置，不易于整体项目接口的升级维护。

##暂不支持

- 不支持数据下载
- 不支持断点续传

##后期目标

- 支持数据下载
- 支持断点续传


##问题反馈

请联系：

​	邮箱：lshxin89@126.com
