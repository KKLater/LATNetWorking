//
//  LATNetError.m
//  LATNetworking
//
//  Created by Later on 16/2/25.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "LATNetError.h"

@implementation LATNetError
@synthesize description;
+ (LATNetError *)netErrorWithCode:(NSInteger)code desc:(NSString*)desc detailErr:(NSError*)detail {
    LATNetError *error = [[LATNetError alloc] init];
    error.code = code;
    error.description = desc;
    error.detail = detail;
    return error;
}
- (void)description_:(NSString *)description_ {
    description = description_;
}
@end
