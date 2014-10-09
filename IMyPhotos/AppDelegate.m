//
//  AppDelegate.m
//  IMyPhotos
//
//  Created by Dracuuula on 13-10-27.
//  Copyright (c) 2013年 D. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "ChoosePictureViewController.h"
//53a82cd756240bb5cd006736

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [UMSocialData setAppKey:@"53a82cd756240bb5cd006736"];
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx5c200edebd2821fe" url:@"http://www.umeng.com/social"];
    
    UINavigationController * rootNav = [[UINavigationController alloc] initWithRootViewController:[[ChoosePictureViewController alloc] init]];
    [rootNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"barbgimage"] forBarMetrics:UIBarMetricsDefault];
    
    [self.window setRootViewController:rootNav];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

@end
