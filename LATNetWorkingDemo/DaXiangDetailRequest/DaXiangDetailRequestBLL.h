//
//  TouTiaoChannelBLL.h
//  LATNetWorkingDemo
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DaXiangDetailResponseEnitity,LATNetError;
@interface DaXiangDetailRequestBLL : NSObject
- (void)startRequestWithId:(NSString *)Id completated:(void(^)(NSDictionary *rspData, DaXiangDetailResponseEnitity *rspObject, LATNetError *error))completated;

@end
