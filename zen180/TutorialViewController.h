//
//  TutorialViewController.h
//  zen180
//
//  Created by iosninjamaster on 7/28/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIPageControl *tutorialPageControl;
    
    
}
@property (nonatomic, strong) IBOutlet UIScrollView *tutorialScrollView;

@property (nonatomic, strong) IBOutlet UIView *tutorialContentView;

- (IBAction)closeTutorial:(id)sender;

@end
