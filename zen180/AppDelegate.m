//
//  AppDelegate.m
//  zen180
//
//  Created by iosninjamaster on 4/30/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "AppDelegate.h"
#import "PageControlHomeViewController.h"
#import "Zen180_IAP_Helper.h"
static NSString *const BaseURLString = @"http://cf56da121053c8adb35e-38b175f4a644da114207134d2e8e6556.r62.cf1.rackcdn.com/Focused%20Mind%205%20-%20Alpha.mp3";

@implementation AppDelegate
@synthesize tutorialDEL;
@synthesize hasStartedDownloadingAwakenedMind;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Zen180_IAP_Helper sharedInstance];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *tempMusicArray = [[NSMutableArray alloc] init];

    
    music = [[Music alloc] init];
    music.title = @"5 minutes";
    music.duration = [NSNumber numberWithInt:5];
    [tempMusicArray addObject:music];
    
    music = [[Music alloc] init];
    music.title = @"15 minutes";
    music.duration = [NSNumber numberWithInt:15];
    [tempMusicArray addObject:music];
    
    music = [[Music alloc] init];
    music.title = @"30 minutes";
    music.duration = [NSNumber numberWithInt:30];
    [tempMusicArray addObject:music];
    
    self.musicArray = tempMusicArray;
    
    self.tutorialDEL = [[TutorialViewController alloc] init];
    

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
    UIApplication  *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask;
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    NSTimeInterval ti = [[UIApplication sharedApplication]backgroundTimeRemaining];
    NSLog(@"backgroundTimeRemaining: %f", ti); // just for debug
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
