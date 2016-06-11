//
//  AppDelegate.m
//  LATNetWorkingDemo
//
//  Created by Later on 16/6/11.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "AppDelegate.h"
#import "UIApplication+LATNetCategory.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //对网络请求整体设置HTTPHeaderFields
    [[UIApplication sharedApplication] setLATNetSetHTTPHeaderFieldsBlock:^NSDictionary *{
        NSMutableDictionary *headers = [NSMutableDictionary new];
        [headers setValue:@"LATNetWorking/1.0.0 (iPhone; iOS 9.3.2; Scale/2.00)" forKey:@"User-Agent"];
        [headers setValue:@"application/octet-stream" forKey:@"Content-Type"];
        [headers setValue:@"keep-alive" forKey:@"Connection"];
        [headers setValue:@"zh-Hans-CN;q=1, ar-CN;q=0.9, pl-PL;q=0.8, de-AT;q=0.7, fr-FR;q=0.6, ru-RU;q=0.5" forKey:@"Accept-Language"];
        [headers setValue:@"gzip, deflate" forKey:@"Accept-Encoding"];
        return headers;
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
