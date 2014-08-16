//
//  FocusedMindViewController.h
//  zen180
//
//  Created by iosninjamaster on 5/11/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AudioPlayer.h"
#import "PageControlHomeViewController.h"
#import "TutorialViewController.h"


@interface FocusedMindViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate>

{
    UIView *theView;
    AppDelegate *appDelegate;
    Music *music;
    PageControlHomeViewController *pageControlViewController;
    
    IBOutlet UIButton *lockedButton;
    IBOutlet UIPickerView *timeOptionsPickerView;
    NSString *musicPlayerState;
    
}
@property (strong, nonatomic) TutorialViewController *tutorialVC;
@property (strong, nonatomic) AudioPlayer *musicPlayer;
@property (strong, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (strong, nonatomic) IBOutlet UILabel *timeElapsed;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property BOOL isPaused;
@property BOOL scrubbing;
@property NSTimer *timer;

@property (nonatomic, strong) IBOutlet UIScrollView *tutorialScrollView;
@property (nonatomic, strong) IBOutlet UIView *tutorialContentView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


- (IBAction)lockedProgramACTION:(id)sender;
- (IBAction)backToHomeACTION:(id)sender;
- (IBAction)toInformationScreenACTION:(id)sender;

- (IBAction)closeTutorial:(id)sender;




@end
