//
//  DaXiangDetailResponseArticle.h
//  LATNetWorkingDemo
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaXiangDetailResponseArticleModel : NSObject
@property (nonatomic, assign) NSInteger  Id;
@property (nonatomic, assign) NSInteger  read_num;
@property (nonatomic, copy) NSString* brief;
@property (nonatomic, copy) NSString* author;
@property (nonatomic, copy) NSString* raw_headpic;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* headpic;
@property (nonatomic, copy) NSString* wechat_url;
@property (nonatomic, assign) NSInteger  create_time;
@property (nonatomic, assign) NSInteger  update_time;
@property (nonatomic, copy) NSString* content;
@end
