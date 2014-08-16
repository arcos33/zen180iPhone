//
//  HomePageViewController.h
//  zen180
//
//  Created by iosninjamaster on 5/8/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"
#import "AwakenedMindViewController.h"
@class AwakenedMindViewController;

@interface HomePageViewController : UIViewController <UIPageViewControllerDataSource>
{
    
}


- (IBAction)browseAudioTracksACTION:(id)sender;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic, strong) AwakenedMindViewController *awakenedMindVC;


@end
