//
//  AppDelegate.h
//  zen180
//
//  Created by iosninjamaster on 4/30/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"
#import "TutorialViewController.h"

@class PageControlHomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Music *music;
    TutorialViewController *tutorialDEL;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *musicArray;
@property (strong, nonatomic) NSString *currentView;
@property (strong, nonatomic) PageControlHomeViewController *pageControlHomeVC;
@property (strong, nonatomic)TutorialViewController *tutorialDEL;

@property (strong, nonatomic) NSNumber * hasStartedDownloadingAwakenedMind;
@end
