//
//  PageControlHomeViewController.h
//  zen180
//
//  Created by iosninjamaster on 5/11/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwakenedMindViewController.h"

@class AwakenedMindViewController;
@class AppDelegate;
@interface PageControlHomeViewController : UIViewController <UIPageViewControllerDataSource>
{
    NSString *viewTitle;
    NSArray *pageImages;
    IBOutlet UIPageControl *pageControl;
    NSMutableArray *vcArray;
    NSArray *vc1;
    AppDelegate *appdelegate;
}

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) AwakenedMindViewController *awakenedMindVC;

- (void)disableScrolling;
- (void)enableScrolling;
@end
