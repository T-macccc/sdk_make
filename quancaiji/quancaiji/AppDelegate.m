//
//  AppDelegate.m
//  quancaiji
//
//  Created by 杨 on 16/2/19.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "AppDelegate.h"

#import "Lotuseed.h"
#import "ViewController.h"
#import "NextViewController.h"
#import "NextViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    Lotuseed *lotuseed;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UITabBarController *tb = [[UITabBarController alloc]init];
    self.window.rootViewController = tb;
    
    ViewController *viewController = [[ViewController alloc]init];
//    viewController.view.backgroundColor = [UIColor greenColor];
    viewController.tabBarItem.title = @"消息";
    viewController.tabBarItem.badgeValue = @"123";
    
    NextViewController *nextViewController = [[NextViewController alloc]init];
    nextViewController.view.backgroundColor = [UIColor grayColor];
    nextViewController.tabBarItem.title = @"联系人";
    
    [tb addChildViewController:viewController];
    [tb addChildViewController:nextViewController];
    
    [self.window makeKeyAndVisible];
    
//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    ViewController *root = [[ViewController alloc]init];
//    root.title = @"Nav";
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
//    
//    
//    [self.window setRootViewController:nav];
//    [self.window makeKeyAndVisible];//nav
    
    lotuseed = [Lotuseed sharedInstanceWithToken:@"apiToken"];
    // Override point for customization after application launch.
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
