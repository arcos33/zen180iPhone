//
//  AwakenedMindViewController.m
//  zen180
//
//  Created by iosninjamaster on 5/11/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "RomanticMindViewController.h"
#import "CreativeMindViewController.h"
#import "AwakenedMindViewController.h"
#import "Music.h"
#import "AFURLSessionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "InformationPageViewController.h"
#import "Zen180_IAP_Helper.h"



@interface RomanticMindViewController ()

@end

@implementation RomanticMindViewController
@synthesize musicPlayer;
@synthesize playButton;
@synthesize currentTimeSlider;
@synthesize timeElapsed;
@synthesize duration;
@synthesize isPaused;
@synthesize scrubbing;
@synthesize timer;


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
    
    Zen180_IAP_Helper *zen180_IAP_Helper = [Zen180_IAP_Helper sharedInstance];
    zen180_IAP_Helper.romanticMindVC = self;
    appDelegate = [[UIApplication sharedApplication]delegate];
    [self reload];
    
    mp3Array = [[NSMutableArray alloc] init];
    
    self.musicPlayer = [[AudioPlayer alloc] init];
    hasStartedDownloading = NO;
    
    [self checkIfFileIsPresent];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    musicPlayerState = @"paused";
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Romantic" owner:self options:nil];
    
    theView = [views objectAtIndex:0];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    timeOptionsPickerView.delegate = self;
    timeOptionsPickerView.hidden = YES;
    self.playButton.hidden = YES;
    
    musicArray = [[NSMutableArray alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.urbndna.RomanticMind_IAP"] == YES || [[NSUserDefaults standardUserDefaults] boolForKey:@"com.urbndna.Pack_IAP"] == YES)
    {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"hasStartedDownloadingRomanticMind"] == YES)
        {
            [self showUnlockButton];
            viewHasAlreadyLoadedOnce = YES;
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"romanticMindDownloadStatus"]  isEqual: @"complete"])
        {
            [self showMusicPlayer];
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    appDelegate.currentView = @"romanticMind";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self checkIfFileIsPresent];
    
    if (fiveMinuteRomanticMindExists)
        [mp3Array addObject:@"1"];
    if (fifteenMinuteRomanticMindExists)
        [mp3Array addObject:@"1"];
    if (thirtyMinuteRomanticMindExists)
        [mp3Array addObject:@"1"];
    
    if (viewHasAlreadyLoadedOnce)
    {
        //don't do anything
    }else if (viewHasAlreadyLoadedOnce == NO)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.urbndna.RomanticMind_IAP"] == YES || [[NSUserDefaults standardUserDefaults] boolForKey:@"com.urbndna.Pack_IAP"] == YES)
        {
            if (allMP3sDownloaded)
            {
                [self showMusicPlayer];
            }
            else if ([[NSUserDefaults standardUserDefaults]boolForKey:@"hasStartedDownloadingRomanticMind"] == YES)
            {
                [self showDownloadWindow];
            }
            else
            {
                [self showUnlockButton];
            }
            
        }
        else
            [self showLockButton];
        
    }
    viewHasAlreadyLoadedOnce = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark in-App purchase
- (void)reload {
    productsArray = nil;
    [[Zen180_IAP_Helper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success)
        {
            productsArray = products;
            NSLog(@"products = %@", productsArray);
        }
    }];
}


- (void)productPurchased:(NSNotification *)notification
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    //NSString *productIdentifier = notification.object;
    [productsArray enumerateObjectsUsingBlock:^(SKProduct *product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:@"com.urbndna.RomanticMind_IAP"] || [product.productIdentifier isEqualToString:@"com.urbndna.Pack_IAP"])
        {
            [tempArray addObject:@"1"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:product.productIdentifier];
        }
        
    }];
    
    if ([productsArray count] >= 1)
    {
        [self.semitransparentView removeFromSuperview];
        [self.purchaseOptionsView removeFromSuperview];
        buyPackView.hidden = NO;
        [lockedButtonOutlet setImage:[UIImage imageNamed:@"unlocked-session-button.png"] forState:UIControlStateNormal];
        fifteenMinuteActivityIndicator.hidden = YES;
        thirtyMinuteActivityIndicator.hidden = YES;
        fiveMinuteDownload.hidden = YES;
        fifteenMinuteDownload.hidden = YES;
        thirtyMinuteDownload.hidden = YES;
        buyPackView.layer.cornerRadius = 5;
        buyPackView.layer.masksToBounds = YES;
        [theView addSubview:buyPackView];
        [self startFiveMinuteActivityIndicator];
        [self downloadFiveMinuteMp3];
    }
}

- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = productsArray[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[Zen180_IAP_Helper sharedInstance] buyProduct:product];
}

- (IBAction)cancel:(id)sender
{
    [self.semitransparentView removeFromSuperview];
    [self.purchaseOptionsView removeFromSuperview];
}

#pragma mark Purchase Options

- (IBAction)buySingleTrack:(id)sender
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (SKProduct *product in productsArray)
    {
        if ([product.productIdentifier isEqualToString:@"com.urbndna.RomanticMind_IAP"])
        {
            [tempArray addObject:product];
        }
    }
    
    SKProduct *product = tempArray[0];
    [[Zen180_IAP_Helper sharedInstance] buyProduct:product];
    

    [userDefaults setBool:YES forKey:@"hasStartedDownloadingRomanticMind"];
    [userDefaults synchronize];

}

- (IBAction)buyPack:(id)sender
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (SKProduct *product in productsArray)
    {
        if ([product.productIdentifier isEqualToString:@"com.urbndna.Pack_IAP"])
        {
            [tempArray addObject:product];
        }
    }
    
    SKProduct *product = tempArray[0];
    [[Zen180_IAP_Helper sharedInstance] buyProduct:product];

}



#pragma mark PickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [appDelegate.musicArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    mp3 = appDelegate.musicArray[row];
    return mp3.title;
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
        [self setupAudioPlayer:@"Compassionate Mind 5 - Gamma"];
        [self.playButton setImage:[UIImage imageNamed:@"play-64.png"] forState:UIControlStateNormal];
    }
    
    else if ([music.title isEqualToString:@"15 minutes"])
    {
        [self setupAudioPlayer:@"Compassionate Mind 15 - Gamma"];
        [self.playButton setImage:[UIImage imageNamed:@"play-64.png"] forState:UIControlStateNormal];
    }
    
    else
        [self setupAudioPlayer:@"Compassionate Mind 30 - Gamma"];
    [self.playButton setImage:[UIImage imageNamed:@"play-64.png"] forState:UIControlStateNormal];
    
}

#pragma mark Main screen

- (IBAction)lockedProgramACTION:(id)sender
{
    [self.view addSubview:theView];
    pageControlViewController = appDelegate.pageControlHomeVC;
    [pageControlViewController disableScrolling];
}



#pragma mark Blue screen
- (void)showLockButton
{
    buyPackView.hidden = YES;
    lockedButtonOutlet.hidden = NO;
    timeOptionsPickerView.hidden = YES;
    self.playButton.hidden = YES;
    self.currentTimeSlider.hidden = YES;
    self.timeElapsed.hidden = YES;
    self.duration.hidden = YES;
}

- (void)showUnlockButton
{
    buyPackView.hidden = YES;
    lockedButtonOutlet.hidden = NO;
    self.currentTimeSlider.hidden = YES;
    self.timeElapsed.hidden = YES;
    self.duration.hidden = YES;
    [lockedButtonOutlet setImage:[UIImage imageNamed:@"unlocked-session-button.png"] forState:UIControlStateNormal];
}

- (void)showDownloadWindow
{
    buyPackView.hidden = NO;
    lockedButtonOutlet.hidden = YES;
}


- (void)showMusicPlayer

{
    buyPackView.hidden = YES;
    lockedButtonOutlet.hidden = YES;
    timeOptionsPickerView.hidden = NO;
    self.playButton.hidden = NO;
    [self.playButton setImage:[UIImage imageNamed:@"play-64.png"]
                     forState:UIControlStateNormal];
    
    self.currentTimeSlider.hidden = NO;
    self.timeElapsed.hidden = NO;
    self.duration.hidden = NO;
    [self setAudioSessionCategoryToPlayback];
    [self setupAudioPlayer:@"Compassionate Mind 5 - Gamma"];
    
}

- (void)showPurchaseOptionsView
{
    [self.view addSubview:self.semitransparentView];
    [self.view addSubview:self.purchaseOptionsView];
    CGRect frame = self.purchaseOptionsView.frame;
    frame.origin.x = 13.5;
    frame.origin.y = 100;
    self.purchaseOptionsView.frame = frame;
}

- (IBAction)toInformationScreenACTION:(id)sender
{
    InformationPageViewController *viewController = [[InformationPageViewController alloc] initWithNibName:@"Info" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)buyIndividualPack:(id)sender
{
    hasStartedDownloading = YES;
    
    if (allMP3sDownloaded)
    {
        [self showMusicPlayer];
    }
    else if ([mp3Array count] > 0 && [mp3Array count] < 3)
    {
        [self showDownloadWindow];
        [self redownload];
        
    }
    else if ([mp3Array count] < 1)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.urbndna.CreativeMind_IAP"] == YES || [[NSUserDefaults standardUserDefaults] boolForKey:@"com.urbndna.Pack_IAP"] == YES)
        {
            buyPackView.hidden = NO;
            lockedButtonOutlet.hidden = YES;
            fiveMinuteDownload.hidden = YES;
            fifteenMinuteDownload.hidden = YES;
            thirtyMinuteDownload.hidden = YES;
            fiveMinuteActivityIndicator.hidden = YES;
            fifteenMinuteActivityIndicator.hidden = YES;
            thirtyMinuteActivityIndicator.hidden = YES;
            [self startFiveMinuteActivityIndicator];
            [self downloadFiveMinuteMp3];
        }else
            
            [self showPurchaseOptionsView];
    }}

- (void)redownload
{
    if(!fiveMinuteRomanticMindExists && fifteenMinuteRomanticMindExists && thirtyMinuteRomanticMindExists)
    {
        buyPackView.hidden = NO;
        [self restartFiveMinuteActivityIndicator];
        [self redownloadFiveMinuteMp3];
        fifteenMinuteDownload.hidden = NO;
        thirtyMinuteDownload.hidden = NO;
        fifteenMinuteActivityIndicator.hidden = YES;
        thirtyMinuteActivityIndicator.hidden = YES;
        fiveMinuteDownload.hidden = YES;
        buyPackView.layer.cornerRadius = 5;
        buyPackView.layer.masksToBounds = YES;
        [theView addSubview:buyPackView];
    }
    
    else if (!fifteenMinuteDownload && fiveMinuteRomanticMindExists && thirtyMinuteRomanticMindExists)
    {
        buyPackView.hidden = NO;
        
        [self restartFifteenMinuteActivityIndicator];
        [self redownloadFifteenMinuteMp3];
        fiveMinuteDownload.hidden = NO;
        thirtyMinuteDownload.hidden = NO;
        fiveMinuteActivityIndicator.hidden = YES;
        thirtyMinuteActivityIndicator.hidden = YES;
        fifteenMinuteDownload.hidden = YES;
        buyPackView.layer.cornerRadius = 5;
        buyPackView.layer.masksToBounds = YES;
        [theView addSubview:buyPackView];
    }
    else if (!thirtyMinuteRomanticMindExists && fiveMinuteRomanticMindExists && fifteenMinuteRomanticMindExists)
    {
        buyPackView.hidden = NO;
        
        [self restartThirtyMinuteActivityIndicator];
        [self redownloadThirtyMinuteMp3];
        fiveMinuteDownload.hidden = NO;
        fifteenMinuteDownload.hidden = NO;
        fiveMinuteActivityIndicator.hidden = YES;
        fifteenMinuteActivityIndicator.hidden = YES;
        thirtyMinuteDownload.hidden = YES;
        buyPackView.layer.cornerRadius = 5;
        buyPackView.layer.masksToBounds = YES;
        [theView addSubview:buyPackView];
    }
    
    
    else if (!fiveMinuteRomanticMindExists && !fifteenMinuteRomanticMindExists && thirtyMinuteRomanticMindExists)
    {
        buyPackView.hidden = NO;
        
        [self restartFiveMinuteActivityIndicator];
        [self redownloadFiveMinuteMp3];
        [self restartFifteenMinuteActivityIndicator];
        [self redownloadFifteenMinuteMp3];
        thirtyMinuteDownload.hidden = NO;
        thirtyMinuteActivityIndicator.hidden = YES;
        
        buyPackView.layer.cornerRadius = 5;
        buyPackView.layer.masksToBounds = YES;
        [theView addSubview:buyPackView];
        
    }
    else if (!fifteenMinuteRomanticMindExists && !thirtyMinuteRomanticMindExists && fiveMinuteRomanticMindExists)
    {
        buyPackView.hidden = NO;
        
        [self restartFifteenMinuteActivityIndicator];
        [self redownloadFifteenMinuteMp3];
        [self restartThirtyMinuteActivityIndicator];
        [self redownloadThirtyMinuteMp3];
        fiveMinuteDownload.hidden = NO;
        fiveMinuteActivityIndicator.hidden = YES;
        fifteenMinuteDownload.hidden = YES;
        fifteenMinuteActivityIndicator.hidden = NO;
        thirtyMinuteDownload.hidden = YES;
        thirtyMinuteActivityIndicator.hidden = NO;
        buyPackView.layer.cornerRadius = 5;
        buyPackView.layer.masksToBounds = YES;
        [theView addSubview:buyPackView];
        
        
    }
    else if (!fiveMinuteRomanticMindExists && !thirtyMinuteRomanticMindExists && fifteenMinuteRomanticMindExists)
    {
        buyPackView.hidden = NO;
        
        [self restartFiveMinuteActivityIndicator];
        [self redownloadFiveMinuteMp3];
        [self restartThirtyMinuteActivityIndicator];
        [self redownloadThirtyMinuteMp3];
        fifteenMinuteDownload.hidden = NO;
        fifteenMinuteActivityIndicator.hidden = YES;
        buyPackView.layer.cornerRadius = 5;
        buyPackView.layer.masksToBounds = YES;
        [theView addSubview:buyPackView];
        
        
    }
}




- (IBAction)backToHomeACTION:(id)sender
{
    [theView removeFromSuperview];
    pageControlViewController = appDelegate.pageControlHomeVC;
    [pageControlViewController enableScrolling];
}
#pragma mark MusicPlayer



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

#pragma mark Download Mp3's
- (void)startFiveMinuteActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        fiveMinuteActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [buyPackView addSubview:fiveMinuteActivityIndicator];
        fiveMinuteActivityIndicator.hidden = NO;
        [fiveMinuteActivityIndicator startAnimating];
        
    });
    
}

- (void)downloadFiveMinuteMp3
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://cf56da121053c8adb35e-38b175f4a644da114207134d2e8e6556.r62.cf1.rackcdn.com/Compassionate%20Mind%205%20-%20Gamma.mp3"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSProgress *progress;
        
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
                                                  
                                                  
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                                                    [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
                                                                    fiveMinutesDone = YES;
                                                                    NSLog(@"fiveMinuteDownload Done");
                                                                    
                                                                    
                                                                    if (error)
                                                                    {
                                                                        NSLog(@"error = %@", [error localizedDescription]);
                                                                        
                                                                        
                                                                    }
                                                                    
                                                                    else
                                                                        dispatch_async(dispatch_get_main_queue(), ^{[fiveMinuteActivityIndicator stopAnimating];
                                                                            NSLog(@"filepath = %@", filePath);
                                                                            
                                                                            
                                                                            
                                                                            fiveMinuteDownload.hidden = NO;
                                                                            fiveMinuteActivityIndicator.hidden = YES;
                                                                            [self startFifteenMinuteActivityIndicator];
                                                                            [self downloadFifteenMinuteMp3];
                                                                        });
                                                                }];
        [downloadTask resume];
        [progress addObserver:self
                   forKeyPath:@"fractionCompleted"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
        
    });
    
}

- (void)startFifteenMinuteActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        fifteenMinuteActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [buyPackView addSubview:fifteenMinuteActivityIndicator];
        fifteenMinuteActivityIndicator.hidden = NO;
        [fifteenMinuteActivityIndicator startAnimating];
        
    });
    
}

- (void)downloadFifteenMinuteMp3
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://cf56da121053c8adb35e-38b175f4a644da114207134d2e8e6556.r62.cf1.rackcdn.com/Compassionate%20Mind%2015%20-%20Gamma.mp3"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
                                                  
                                                  
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                                                    NSLog(@"fifteenMinuteDownload Done");
                                                                    
                                                                    if (error)
                                                                    {
                                                                        NSLog(@"error = %@", [error localizedDescription]);
                                                                    }
                                                                    
                                                                    else
                                                                        dispatch_async(dispatch_get_main_queue(), ^{[fifteenMinuteActivityIndicator stopAnimating];
                                                                            fifteenMinuteActivityIndicator.hidden = YES;
                                                                            fifteenMinuteDownload.hidden = NO;
                                                                            [self startThirtyMinuteActivityIndicator];
                                                                            [self downloadThirtyMinuteMp3];
                                                                        });
                                                                }];
        [downloadTask resume];
    });
    
}

- (void)startThirtyMinuteActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        thirtyMinuteActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [buyPackView addSubview:thirtyMinuteActivityIndicator];
        thirtyMinuteActivityIndicator.hidden = NO;
        [thirtyMinuteActivityIndicator startAnimating];
        
    });
    
}

- (void)downloadThirtyMinuteMp3
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://cf56da121053c8adb35e-38b175f4a644da114207134d2e8e6556.r62.cf1.rackcdn.com/Compassionate%20Mind%2030%20-%20Gamma.mp3"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSProgress *progress;
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
                                                  
                                                  
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                                                    NSLog(@"thirtyMinuteDownload Done");
                                                                    
                                                                    if (error)
                                                                    {
                                                                        NSLog(@"error = %@", [error localizedDescription]);
                                                                        [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
                                                                        
                                                                    }
                                                                    
                                                                    else
                                                                        dispatch_async(dispatch_get_main_queue(), ^{[thirtyMinuteActivityIndicator stopAnimating];
                                                                            [progress addObserver:self
                                                                                       forKeyPath:@"fractionCompleted"
                                                                                          options:NSKeyValueObservingOptionNew
                                                                                          context:NULL];
                                                                            
                                                                            thirtyMinuteActivityIndicator.hidden = YES;
                                                                            thirtyMinuteDownload.hidden = NO;
                                                                            [self ifAllDoneRemoveDownloadWindow];
                                                                            
                                                                            
                                                                        });
                                                                }];
        [downloadTask resume];
    });
    
}

#pragma mark RE-Download Mp3's
- (void)restartFiveMinuteActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        fiveMinuteActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [buyPackView addSubview:fiveMinuteActivityIndicator];
        fiveMinuteActivityIndicator.hidden = NO;
        [fiveMinuteActivityIndicator startAnimating];
        
    });
    
}


- (void)redownloadFiveMinuteMp3
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://cf56da121053c8adb35e-38b175f4a644da114207134d2e8e6556.r62.cf1.rackcdn.com/Compassionate%20Mind%205%20-%20Gamma.mp3"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSProgress *progress;
        
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
                                                  
                                                  
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                                                    [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
                                                                    fiveMinutesDone = YES;
                                                                    NSLog(@"fiveMinuteDownload Done");
                                                                    
                                                                    
                                                                    if (error)
                                                                    {
                                                                        NSLog(@"error = %@", [error localizedDescription]);
                                                                        
                                                                        
                                                                    }
                                                                    
                                                                    else
                                                                        dispatch_async(dispatch_get_main_queue(), ^{[fiveMinuteActivityIndicator stopAnimating];
                                                                            NSLog(@"filepath = %@", filePath);
                                                                            
                                                                            
                                                                            
                                                                            fiveMinuteDownload.hidden = NO;
                                                                            fiveMinuteActivityIndicator.hidden = YES;
                                                                            //[self startFifteenMinuteActivityIndicator];
                                                                            //[self downloadFifteenMinuteMp3];
                                                                            [self ifAllDoneRemoveDownloadWindow];
                                                                        });
                                                                }];
        [downloadTask resume];
        [progress addObserver:self
                   forKeyPath:@"fractionCompleted"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
        
    });
    
}

- (void)restartFifteenMinuteActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        fifteenMinuteActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [buyPackView addSubview:fifteenMinuteActivityIndicator];
        fifteenMinuteActivityIndicator.hidden = NO;
        [fifteenMinuteActivityIndicator startAnimating];
        
    });
    
}

- (void)redownloadFifteenMinuteMp3
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://cf56da121053c8adb35e-38b175f4a644da114207134d2e8e6556.r62.cf1.rackcdn.com/Compassionate%20Mind%2015%20-%20Gamma.mp3"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
                                                  
                                                  
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                                                    NSLog(@"fifteenMinuteDownload Done");
                                                                    
                                                                    if (error)
                                                                    {
                                                                        NSLog(@"error = %@", [error localizedDescription]);
                                                                    }
                                                                    
                                                                    else
                                                                        dispatch_async(dispatch_get_main_queue(), ^{[fifteenMinuteActivityIndicator stopAnimating];
                                                                            fifteenMinuteActivityIndicator.hidden = YES;
                                                                            fifteenMinuteDownload.hidden = NO;
                                                                            //[self startThirtyMinuteActivityIndicator];
                                                                            //[self downloadThirtyMinuteMp3];
                                                                            [self ifAllDoneRemoveDownloadWindow];
                                                                        });
                                                                }];
        [downloadTask resume];
    });
    
}

- (void)restartThirtyMinuteActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        thirtyMinuteActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [buyPackView addSubview:thirtyMinuteActivityIndicator];
        thirtyMinuteActivityIndicator.hidden = NO;
        [thirtyMinuteActivityIndicator startAnimating];
        
    });
    
}

- (void)redownloadThirtyMinuteMp3
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://cf56da121053c8adb35e-38b175f4a644da114207134d2e8e6556.r62.cf1.rackcdn.com/Compassionate%20Mind%2030%20-%20Gamma.mp3"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSProgress *progress;
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
                                                  
                                                  
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                                                    NSLog(@"thirtyMinuteDownload Done");
                                                                    
                                                                    if (error)
                                                                    {
                                                                        NSLog(@"error = %@", [error localizedDescription]);
                                                                        [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
                                                                        
                                                                    }
                                                                    
                                                                    else
                                                                        dispatch_async(dispatch_get_main_queue(), ^{[thirtyMinuteActivityIndicator stopAnimating];
                                                                            [progress addObserver:self
                                                                                       forKeyPath:@"fractionCompleted"
                                                                                          options:NSKeyValueObservingOptionNew
                                                                                          context:NULL];
                                                                            
                                                                            thirtyMinuteActivityIndicator.hidden = YES;
                                                                            thirtyMinuteDownload.hidden = NO;
                                                                            [self ifAllDoneRemoveDownloadWindow];
                                                                            
                                                                            
                                                                        });
                                                                }];
        [downloadTask resume];
    });
    
}








- (void)successAlert
{
    successAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Romantic Mind- Download Successful" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [successAlert show];
    [userDefaults setValue:@"complete" forKey:@"romanticMindDownloadStatus"];
    [userDefaults synchronize];
    buyPackView.hidden = YES;
    lockedButtonOutlet.hidden = YES;
    timeOptionsPickerView.hidden = NO;
    self.playButton.hidden = NO;
    [self.playButton setImage:[UIImage imageNamed:@"play-64.png"]
                     forState:UIControlStateNormal];
    self.currentTimeSlider.hidden = NO;
    self.timeElapsed.hidden = NO;
    self.duration.hidden = NO;
    //[theView removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   
}


- (void) checkIfFileIsPresent
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fiveMinuteMp3 = [documentsDirectory stringByAppendingPathComponent:@"Compassionate Mind 5 - Gamma.mp3"];
    NSString *fifteenMinuteMp3 = [documentsDirectory stringByAppendingPathComponent:@"Compassionate Mind 15 - Gamma.mp3"];
    NSString *thirtyMinuteMp3 = [documentsDirectory stringByAppendingPathComponent:@"Compassionate Mind 30 - Gamma.mp3"];
    
    fiveMinuteRomanticMindExists = [[NSFileManager defaultManager] fileExistsAtPath:fiveMinuteMp3];
    
    fifteenMinuteRomanticMindExists = [[NSFileManager defaultManager] fileExistsAtPath:fifteenMinuteMp3];
    
    thirtyMinuteRomanticMindExists = [[NSFileManager defaultManager] fileExistsAtPath:thirtyMinuteMp3];
    
    if (fiveMinuteRomanticMindExists == YES && fifteenMinuteRomanticMindExists == YES && thirtyMinuteRomanticMindExists == YES)
    {
        allMP3sDownloaded = YES;
    }
    
}




- (void)ifAllDoneRemoveDownloadWindow
{
    [self checkIfFileIsPresent];
    
    if (allMP3sDownloaded)
    {
        [userDefaults setValue:@"complete" forKey:@"romanticMindDownloadStatus"];
        [userDefaults setBool:NO forKey:@"hasStartedDownloadingRomanticMind"];
        [userDefaults synchronize];
        buyPackView.hidden = YES;
        lockedButtonOutlet.hidden = YES;
        timeOptionsPickerView.hidden = NO;
        self.playButton.hidden = NO;
        [self.playButton setImage:[UIImage imageNamed:@"play-64.png"]
                         forState:UIControlStateNormal];
        self.currentTimeSlider.hidden = NO;
        self.timeElapsed.hidden = NO;
        self.duration.hidden = NO;
        [self setupAudioPlayer:@"Compassionate Mind 5 - Gamma"];
		
    }
    
}



@end
