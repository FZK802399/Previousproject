//
//  AudioPlayer.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-3.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

@synthesize audioPlayer = _audioPlayer;
@synthesize slider = _slider;
@synthesize duration = _duration;
@synthesize currentTime = _currentTime;

@synthesize timer = _timer;
@synthesize soundSlider = _soundSlider;
@synthesize playerState = _playerState;
@synthesize volume = _volume;
@synthesize wasSoundOff = _wasSoundOff;


- (void)dealloc
{
    Release(_slider);
    Release(_timer);
    Release(_duration);
    Release(_currentTime);
    Release(_audioPlayer);
    Release(_soundSlider);
    [_timer invalidate];
    
    [super dealloc];
}

- (id)initWithUrl:(NSURL *)path
{
    if (self = [super init])
    {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
    }
    return self;
}

+ (id)getInstance
{
    static AudioPlayer *audioPlayer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [[AudioPlayer alloc] init];
        [audioPlayer loadTimer];
        audioPlayer.volume = 1.0f;
    });
    return audioPlayer;
}

- (void)setSoundFilePath:(NSURL *)url andPlay:(BOOL)play
{
    [self stop];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_audioPlayer setDelegate:self];
    _audioPlayer.volume = _soundSlider.value;
    int seconds = (int)_audioPlayer.duration;
    _duration.text = [self timeFromSecond:seconds];
    if (!error && play)
    {
        [_audioPlayer prepareToPlay];
        [self play];
    }
}

- (void)setSlider:(UISlider *)slider
{
    if (_slider != slider)
    {
        [_slider release];
        _slider = [slider retain];
        
        [_slider addTarget:self action:@selector(pauseTimer) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(updateTime) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
}

- (void)setSoundSlider:(UISlider *)soundSlider
{
    if (_soundSlider != soundSlider)
    {
        [_soundSlider release];
        _soundSlider = [soundSlider retain];
        
        [_soundSlider addTarget:self action:@selector(valumeChenged:) forControlEvents:UIControlEventValueChanged];
        [_soundSlider addTarget:self action:@selector(valueDidEndChanged:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        _soundSlider.value = 1.0f;
        
        [_slider addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)pauseTimer
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)continueTimer
{
    [_timer setFireDate:[NSDate date]];
}

- (void)valumeChenged:(id)sender
{
    [_audioPlayer setVolume:_soundSlider.value];
}

- (void)valueDidEndChanged:(id)sender
{
    if (_soundSlider.value < 0.00001)
    {
        _wasSoundOff = YES;
    }
    else
    {
        _wasSoundOff = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_SOUND_VALUME_CHANGED object:nil];
}

- (void)updateTime
{ 
    if (_playerState == PlayerStatePlaying)
    {
        NSTimeInterval time = _audioPlayer.duration * _slider.value;
        _audioPlayer.currentTime = time;
        [self continueTimer];
    }
    else if (_slider.value == 1.0f)
    {
        _audioPlayer.currentTime = 0.0f;
        _slider.value = _audioPlayer.currentTime;
    }
}

- (void)soundOff
{
    _volume = _soundSlider.value;    
    _audioPlayer.volume = 0.0f;
    _soundSlider.value = 0.0f;
    _wasSoundOff = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_SOUND_VALUME_CHANGED object:nil];
}
- (void)soundOn
{
    _audioPlayer.volume = _volume;
    _soundSlider.value = _volume;
    _wasSoundOff = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_SOUND_VALUME_CHANGED object:nil];
}

- (void)stop
{
    if (_audioPlayer)
    {
        [_audioPlayer stop];
        _playerState = PlayerStateStop;
        [_audioPlayer release];
        [self pauseTimer];
        [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_STATE_CHANGED object:nil];
    }
}

- (void)play
{
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    _playerState = PlayerStatePlaying;
    [self continueTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_STATE_CHANGED object:nil];
}
- (void)pause
{
    [_audioPlayer pause];
    _playerState = PlayerStatePause;
    [self pauseTimer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_STATE_CHANGED object:nil];
}

- (void)loadTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(changeSlider) userInfo:nil repeats:YES];
    [self pauseTimer];
}

- (void)changeSlider
{
    float value = _audioPlayer.currentTime / _audioPlayer.duration;
    [_slider setValue:value];
}

#pragma mark -
#pragma mark audio player delegate method
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _playerState = PlayerStateStop;
    [_audioPlayer setCurrentTime:0.0f];
    [self pauseTimer];
    [_slider setValue:_audioPlayer.currentTime];
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_STATE_CHANGED object:nil];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"bbbbbb");
}

- (NSString *)timeFromSecond:(NSInteger)second
{
    if (second < 10)
    {
        return [NSString stringWithFormat:@"00:0%d",second];
    }
    if (second < 60)
    {
        return [NSString stringWithFormat:@"00:%d",second];
    }
    if (second/60 < 10 && second%60 < 10)
    {
        return [NSString stringWithFormat:@"0%d:0%d",second/60,second%60];
    }
    if (second/60 < 10 && second%60 >= 10)
    {
        return [NSString stringWithFormat:@"0%d:%d",second/60,second%60];
    }
    if (second/60 >= 10 && second%60 < 10)
    {
        return [NSString stringWithFormat:@"%d:0%d",second/60,second%60];
    }
    if (second/60 >= 10 && second%60 >=10)
    {
        return [NSString stringWithFormat:@"%d:%d",second/60,second%60];
    }
    return nil;
}
- (double)secondFromTime:(NSString *)time
{
    return 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    int secods = _audioPlayer.duration * _slider.value;
    _currentTime.text = [self timeFromSecond:secods];
}

@end
