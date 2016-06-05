//
//  AppDelegate.m
//  zhiwenNotificaition
//
//  Created by boyancao on 16/6/4.
//  Copyright © 2016年 boyancao. All rights reserved.
//

#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *controller = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1/255.0f green:152/255.0f blue:117/255.0f alpha:1]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName :[UIColor whiteColor]}];
    
    LAContext * context = [LAContext new];
    
    // 3.判断用户是否设置了Touch ID
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        //4. 开始使用指纹识别
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹验证登录" reply:^(BOOL success, NSError *error) {
            //4.1 验证成功
            if (success) {
                NSLog(@"验证成功");
            }
            
            //4.2 验证失败
            NSLog(@"error: %ld",error.code);
            
            if (error.code == -2) {
                NSLog(@"用户自己取消");
                exit(0);
            }
            
            if (error.code != 0 && error.code != -2) {
                
                
                NSLog(@"验证失败");
            }
        }];
    } else {
        NSLog(@"请先设置Touch ID");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
