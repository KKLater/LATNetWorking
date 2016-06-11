//
//  TouTiaoChannelBLL.m
//  LATNetWorkingDemo
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "DaXiangDetailRequestBLL.h"
#import "DaXiangDetailRequestEnitity.h"
#import "DaXiangDetailResponseEnitity.h"
@interface DaXiangDetailRequestBLL()
@property (strong, nonatomic) DaXiangDetailRequestEnitity *requestEnitity;
@end
@implementation DaXiangDetailRequestBLL
- (instancetype)init {
    if (self = [super init]) {
        self.requestEnitity = [[DaXiangDetailRequestEnitity alloc] init];
        self.requestEnitity.responseClass = [DaXiangDetailResponseEnitity class];
    }
    return self;
}
- (void)startRequestWithId:(NSString *)Id completated:(void(^)(NSDictionary *rspData, DaXiangDetailResponseEnitity *rspObject, LATNetError *error))completated {
    self.requestEnitity.id = Id;
    [self.requestEnitity setLATRequestResultBlock:^(id _Nullable rspData, DaXiangDetailResponseEnitity * _Nullable rspObject, LATNetError * _Nullable httpError) {
        !completated ?: completated(rspData,rspObject,httpError);
    }];
    [self.requestEnitity startRequest];

}
@end
