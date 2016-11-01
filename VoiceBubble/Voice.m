//
//  Voice.m
//  VoiceBubble
//
//  Created by kelvin on 15/11/25.
//  Copyright © 2015年 kelvin. All rights reserved.
//

#import "Voice.h"

@implementation Voice

- (id)initWithDuration:(int)du
{
    self = [super init];
    if (self) {
        _initDuration = du;
        _playState = enum_VoiceMail_PlayState_Stop;
        _audioRoute = kVoiceMessageAudioRouteSpeaker;
        _duration = _initDuration;
        
    }
    return self;
}
- (void)timerFuncRefreshRemainTime
{
    _duration--;
    
    if (_duration == 0)
    {
        [_timer invalidate];
        _timer = nil;
        _playState = enum_VoiceMail_PlayState_Stop;
        _duration = _initDuration;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationVoiceUpdate object:[NSNumber numberWithInt:_duration]];
}
# pragma mark VoiceBubbleViewDelegate

- (int)getDuration
{
    return _duration;
}

- (enum_VoiceMail_PlayState)getPlayState
{
    return _playState;
}

- (VoiceMessageAudioRoute)getAudioRotateState
{
    return _audioRoute;
}


- (void)play
{
    if (_playState == enum_VoiceMail_PlayState_Invalid)
    {
        NSLog(@"Invalid voice");
    }
    else if(_playState == enum_VoiceMail_PlayState_Stop)
    {
        _duration = _initDuration;
        _playState = enum_VoiceMail_PlayState_Playing;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFuncRefreshRemainTime) userInfo:nil repeats:YES];
    }
    else if (_playState == enum_VoiceMail_PlayState_Pause)
    {
        _playState = enum_VoiceMail_PlayState_Playing;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFuncRefreshRemainTime) userInfo:nil repeats:YES];
    }
    else if (_playState == enum_VoiceMail_PlayState_Playing)
    {
        _playState = enum_VoiceMail_PlayState_Pause;
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)audioSwitched:(BOOL)on
{
    
}
@end
