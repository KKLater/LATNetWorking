//
//  UIApplication+LATNetCategory.m
//  LATNetWorkingDemo
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "UIApplication+LATNetCategory.h"
#import <objc/runtime.h>
@implementation UIApplication (LATNetCategory)
- (void)setLATNetSetHTTPHeaderFieldsBlock:(NSDictionary *(^)())LATNetSetHTTPHeaderFieldsBlock {
    objc_setAssociatedObject(self, @selector(LATNetSetHTTPHeaderFieldsBlock), LATNetSetHTTPHeaderFieldsBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary *(^)())LATNetSetHTTPHeaderFieldsBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLATRequestParametersFormatBlock:(NSDictionary *(^)(NSDictionary *))LATRequestParametersFormatBlock {
    objc_setAssociatedObject(self, @selector(LATRequestParametersFormatBlock), LATRequestParametersFormatBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary *(^)(NSDictionary *))LATRequestParametersFormatBlock {
    return objc_getAssociatedObject(self, _cmd);
}
@end
