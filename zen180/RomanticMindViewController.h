//
//  CreativeMindViewController.h
//  zen180
//
//  Created by iosninjamaster on 5/11/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"
#import "HomePageViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"
#import "PageControlHomeViewController.h"
#import <StoreKit/StoreKit.h>

@class PageControlHomeViewController;
@class AppDelegate;

@interface RomanticMindViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSUserDefaults *userDefaults;
    UIAlertView *successAlert;
    NSString *musicPlayerState;
    NSMutableArray *theArray;
    NSMutableArray *mp3Array;
    NSArray *productsArray;

    BOOL viewHasAlreadyLoadedOnce;

    BOOL allMP3sDownloaded;

    BOOL fiveMinutesDone;
    BOOL fiveMinuteRomanticMindExists;
    BOOL fifteenMinuteRomanticMindExists;
    BOOL thirtyMinuteRomanticMindExists;
    BOOL hasStartedDownloading;

    
    IBOutlet UIImageView *fiveMinuteDownload;
    IBOutlet UIImageView *fifteenMinuteDownload;
    IBOutlet UIImageView *thirtyMinuteDownload;
    
    IBOutlet UIButton *lockedButtonOutlet;
    
    IBOutlet UIView *buyPackView;
    MBProgressHUD *hud;
    NSMutableArray *musicArray;
    NSString *mp3File;
    UIView *theView;
    UIView *oldPickerView;
    UIView *selectedPickerView;
    IBOutlet UIActivityIndicatorView *fiveMinuteActivityIndicator;
    IBOutlet UIActivityIndicatorView *fifteenMinuteActivityIndicator;
    IBOutlet UIActivityIndicatorView *thirtyMinuteActivityIndicator;
    Music *music;
    PageControlHomeViewController *pageControlViewController;
    UIImageView *imageView;
    NSArray *timeOptions;
    Music *mp3;
    AppDelegate *appDelegate;
    AVAudioPlayer *audioPlayer;
    IBOutlet UIPickerView *timeOptionsPickerView;
}


- (IBAction)backToHomeACTION:(id)sender;
- (IBAction)toInformationScreenACTION:(id)sender;
- (IBAction)buyIndividualPack:(id)sender;
- (IBAction)playAudioPressed:(id)playButton;

- (IBAction)buySingleTrack:(id)sender;
- (IBAction)buyPack:(id)sender;
- (IBAction)cancel:(id)sender;


@property (strong, nonatomic) AudioPlayer *musicPlayer;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (strong, nonatomic) IBOutlet UILabel *timeElapsed;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UIView *semitransparentView;
@property (strong, nonatomic) IBOutlet UIView *purchaseOptionsView;
@property BOOL isPaused;
@property BOOL scrubbing;
@property NSTimer *timer;
@property (strong, nonatomic) UIRefreshControl *refreshControl;



@end
