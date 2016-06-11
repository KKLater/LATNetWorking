//
//  DaXiangDetailResponseEnitity.h
//  LATNetWorkingDemo
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaXiangDetailResponseHeadModel.h"
#import "DaXiangDetailResponseBodyModel.h"

@interface DaXiangDetailResponseEnitity : NSObject
@property (nonatomic, strong) DaXiangDetailResponseHeadModel * head;
@property (nonatomic, strong) DaXiangDetailResponseBodyModel * body;
@end
