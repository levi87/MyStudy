//
//  AppDelegate.m
//  freebao
//
//  Created by freebao on 13-5-28.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "HomeLineViewController.h"
#import "LoginViewController.h"
#import "FollowerVC.h"
#import "SettingVC.h"
#import "ProfileVC.h"
#import "FollowAndFansVC.h"
#import "MetionsStatusesVC.h"
#import "ZJTProfileViewController.h"
#import "MessageViewController.h"

@implementation AppDelegate
@synthesize managedObjContext = _managedObjContext;
@synthesize managedObjModel = _managedObjModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    HomeLineViewController *HomeVC = [[HomeLineViewController alloc] initWithNibName:@"HomeLineViewController" bundle:nil];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:HomeVC];
    nav1.navigationBar.tintColor = [UIColor blackColor];
//    [nav1.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    
    SettingVC *Settings= [[SettingVC alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:Settings];
//    [nav2.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    nav2.navigationBar.tintColor = [UIColor blackColor];
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabbar_more"];
    
    MetionsStatusesVC *MesVC = [[MetionsStatusesVC alloc] initWithNibName:@"HomeLineViewController" bundle:nil];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:MesVC];
//    [nav2.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    nav3.navigationBar.tintColor = [UIColor blackColor];
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabbar_message_center"];
    
    LoginViewController *Login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:Login];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:nav1, nav3, nav2, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    [self.window.rootViewController presentViewController:navLogin animated:NO completion:nil];
    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
