//
//  ViewController.m
//  LATNetWorkingDemo
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "ViewController.h"
#import "DaXiangDetailRequestBLL.h"
#import "DaXiangDetailResponseEnitity.h"
@class LATNetError;
@interface ViewController ()
@property (nonatomic, strong) DaXiangDetailRequestBLL *requestBLL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)startRequest:(id)sender {
    //分布式网络请求
    [self.requestBLL startRequestWithId:@"672" completated:^(NSDictionary *rspData, DaXiangDetailResponseEnitity *rspObject, LATNetError *error) {
        NSLog(@"rspData = %@, rspObject = %@, NetError = %@",rspData, rspObject, error);
    }];
}
- (IBAction)startRequestManager:(id)sender {
    //集中式网络请求
    [[LATNetAFNRequestManager sharedManager] startRequestWithMethod:@"GET" requestURLString:@"http://app.idaxiang.org/api/v1_0/art/info?id=672" requestParameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];

}

- (DaXiangDetailRequestBLL *)requestBLL {
    if (!_requestBLL) {
        _requestBLL = [[DaXiangDetailRequestBLL alloc] init];
    }
    return _requestBLL;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
