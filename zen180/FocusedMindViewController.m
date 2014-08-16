//
//  FocusedMindViewController.m
//  zen180
//
//  Created by iosninjamaster on 5/11/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "FocusedMindViewController.h"
#import "InformationPageViewController.h"
#import "Zen180_IAP_Helper.h"

@interface FocusedMindViewController ()

@end

@implementation FocusedMindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    musicPlayerState = @"paused";

    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Focused" owner:self options:nil];
    theView = views[0];
    appDelegate = [[UIApplication sharedApplication] delegate];
    timeOptionsPickerView.delegate = self;
    lockedButton.hidden = NO;
    
    [self.playButton setImage:[UIImage imageNamed:@"play-64.png"]
                     forState:UIControlStateNormal];
    [self setAudioSessionCategoryToPlayback];
    self.musicPlayer = [[AudioPlayer alloc] init];
    [self setupAudioPlayer:@"Focused Mind 5 - Alpha"]; //doing this on viewDidLoad makes sure that 5 minute mp3 is loaded as soon as pickerViewloads
    
}

- (void)viewWillAppear:(BOOL)animated
{
    appDelegate.currentView = @"focusedMind";

}



- (void)viewDidAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"saw_tutorial"] == NO)
    {
        self.tutorialScrollView.delegate = self;
        self.tutorialScrollView.contentSize = CGSizeMake(960, 568);
        [self.tutorialScrollView addSubview:self.tutorialContentView];
        [self.view addSubview:self.tutorialScrollView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"saw_tutorial"];
    }

    
}

- (void)setupAudioPlayer:(NSString*)fileName
{
    //insert Filename & FileExtension
    NSString *fileExtension = @"mp3";
    
    //init the Player to get file properties to set the time labels
    [self.musicPlayer initPlayer:fileName fileExtension:fileExtension];
    self.currentTimeSlider.maximumValue = [self.musicPlayer getAudioDuration];
    
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
    self.timeElapsed.text = @"0:00";
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.musicPlayer timeFormat:[self.musicPlayer getAudioDuration]]];
    
}

/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playAudioPressed:(id)playButton
{
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setImage:[UIImage imageNamed:@"pause-64.png"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.musicPlayer playAudio];
        self.isPaused = TRUE;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setImage:[UIImage imageNamed:@"play-64.png"]
                                   forState:UIControlStateNormal];
        
        [self.musicPlayer pauseAudio];
        self.isPaused = FALSE;
    }

}




/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        self.currentTimeSlider.value = [self.musicPlayer getCurrentAudioTime];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.musicPlayer timeFormat:[self.musicPlayer getCurrentAudioTime]]];
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.musicPlayer timeFormat:[self.musicPlayer getAudioDuration] - [self.musicPlayer getCurrentAudioTime]]];
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.musicPlayer setCurrentAudioTime:self.currentTimeSlider.value];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */

- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAudioSessionCategoryToPlayback
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ok;
    NSError *setCategoryError = nil;
    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!ok)
    {
        NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [appDelegate.musicArray count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    music = appDelegate.musicArray[row];
    return music.title;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *aString = [self pickerView:pickerView titleForRow:row forComponent:component];
    NSAttributedString *bString = [[NSAttributedString alloc] initWithString:aString attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return bString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    music = appDelegate.musicArray[row];
    if ([music.title isEqualToString:@"5 minutes"])
    {
        [self setupAudioPlayer:@"Focused Mind 5 - Alpha"];
        [self.playButton setImage:[UIImage imageNamed:@"play-64.png"] forState:UIControlStateNormal];
        
        
    }
    
    else if ([music.title isEqualToString:@"15 minutes"])
    {
        [self setupAudioPlayer:@"Focused Mind 15 - Alpha"];
        [self.playButton setImage:[UIImage imageNamed:@"play-64.png"] forState:UIControlStateNormal];
        
    }
    
    else
        [self setupAudioPlayer:@"Focused Mind 30 - Alpha"];
    [self.playButton setImage:[UIImage imageNamed:@"play-64.png"] forState:UIControlStateNormal];
    
    
}


- (IBAction)lockedProgramACTION:(id)sender
{
    [self.view addSubview:theView];
    pageControlViewController = appDelegate.pageControlHomeVC;
    [pageControlViewController disableScrolling];
}

- (IBAction)backToHomeACTION:(id)sender
{
    [theView removeFromSuperview];
    pageControlViewController = appDelegate.pageControlHomeVC;
    [pageControlViewController enableScrolling];
}


- (IBAction)toInformationScreenACTION:(id)sender
{
    InformationPageViewController *viewController = [[InformationPageViewController alloc] initWithNibName:@"Info" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)closeTutorial:(id)sender
{
    [self.tutorialScrollView removeFromSuperview];
}



@end
