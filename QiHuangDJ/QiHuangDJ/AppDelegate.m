//
//  AppDelegate.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-17.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNavViewController.h"
#import "ViewController.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "MobClick.h"
#import "APService.h"
#import <ShareSDK/ShareSDK.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //友盟统计
    [MobClick startWithAppkey:@"5461a154fd98c5ce9f0073b4" reportPolicy:BATCH   channelId:@""];
    
    //register umeng
     [UMSocialData setAppKey:@"5461a154fd98c5ce9f0073b4"];
    
//    //打开新浪微博的SSO开关
//    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
//
     [ShareSDK registerApp:@"4521b8898422"];
    
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"2058806096"
                               appSecret:@"7ad95e9c8d929be4014c039da27dedab"
                             redirectUri:@"http://175kh.com"];
    [ShareSDK connectTencentWeiboWithAppKey:@"101149800" appSecret:@"fd01fe1b65ac6a20b97747fd5d570948" redirectUri:@"yxq.175kh.com"];
//    [ShareSDK connectQQWithAppKey:@"101104063" appSecret:@"9f2c54ba9cf54cd2e55fdb6cb862230e"];
//    [ShareSDK connectQQWithAppId:<#(NSString *)#> qqApiCls:<#(__unsafe_unretained Class)#>]
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController * vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    CustomNavViewController * navCustom = [[CustomNavViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navCustom;
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //JPush
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}
#pragma mark -umeng sina share redirect method
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [ShareSDK handleOpenURL:url wxDelegate:nil];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}

#pragma mark -JPush Redirect Method
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
