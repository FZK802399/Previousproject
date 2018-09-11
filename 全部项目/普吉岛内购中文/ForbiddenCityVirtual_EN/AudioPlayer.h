//
//  AudioPlayer.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-3.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <Foundation/Foundation.h>

enum PlayerState {
    PlayerStateStop,
    PlayerStatePause,
    PlayerStatePlaying
    };
typedef NSInteger PlayerState;

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate>
{
    AVAudioPlayer *_audioPlayer;
    UISlider *_slider;
    UISlider *_soundSlider;
    
    NSTimer *_timer;
}
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UISlider *soundSlider;
@property (nonatomic, strong) UILabel *duration;
@property (nonatomic, strong) UILabel *currentTime;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) PlayerState playerState;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) BOOL wasSoundOff;

- (void)play;
- (void)pause;

- (id)initWithUrl:(NSURL *)path;
+ (id)getInstance;
- (void)setSoundFilePath:(NSURL *)url andPlay:(BOOL)play;

- (void)soundOff;
- (void)soundOn;

- (NSString *)timeFromSecond:(NSInteger)second;
- (double)secondFromTime:(NSString *)time;
@end
