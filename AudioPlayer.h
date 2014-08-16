//
//  AudioPlayer.h
//  zen180
//
//  Created by iosninjamaster on 5/28/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AppDelegate;

@interface AudioPlayer : NSObject
{
    AppDelegate *appDelegate;
}




@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

// Public methods
- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension;
- (void)playAudio;
- (void)pauseAudio;
- (void)setCurrentAudioTime:(float)value;
- (float)getAudioDuration;
- (NSString*)timeFormat:(float)value;
- (NSTimeInterval)getCurrentAudioTime;
@end
