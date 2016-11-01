//
//  VoiceBubbleView.m
//  VoiceBubble
//
//  Created by kelvin on 15/11/20.
//  Copyright © 2015年 kelvin. All rights reserved.
//

#import "VoiceBubbleView.h"

#define CELL_FOR_VOICE_HEIGHT 35
#define CELL_FOR_VOICE_WIDTH  100
#define PLAY_VOICE_IMAGE_VIEW_HEIGHT    31
#define PLAY_VOICE_IMAGE_VIEW_WIDTH     20.5
#define SHOW_TIME_LABEL_HEIGHT          15
#define SHOW_TIME_LABEL_WIDTH           24 // base
#define SHOW_DOWN_LOADING_HEIGHT        10
#define SHOW_DOWN_LOADING_WIDTH         10
#define SPEAKING_SHOW_HEIGHT            8
#define SPEAKING_SHOW_WIDTH             8

#define KSwitchWidth 98.0f
#define kSwitchHeight 28.0f
#define kSwitchBubbleOffset 10.0f

#define VOICE_MESSAGE_DURATION_MS_TO_S(x)  (int)(round((x)/1000.0))
#define VOICE_MAIL_INIT_DURATION    20


#define kTimeLabelHeight  16.0f
#define kTimeLabelOffsetY   6.0f



@interface VoiceBubbleView()
{
    CGPoint _startPoint;
}
@end

@implementation VoiceBubbleView

- (void)handleClick
{
    if (_vbDelegate && [_vbDelegate respondsToSelector:@selector(play)])
    {
        [_vbDelegate play];
    }
    
    [self updateUIForPlayState];
}

- (id)initWithPosition: (CGPoint)point andDuration:(int)duration speakerState:(VoiceMessageAudioRoute)spState
{
    self = [super init];
    if (self)
    {
        _startPoint = point;
        _panelView = [[UIButton alloc] init]; //default size
        _panelView.backgroundColor = [UIColor colorWithRed:121.0/255.0 green:193.0/255.0 blue:242.0/255.0 alpha:1.0];
        _panelView.layer.cornerRadius = 4;
        _panelView.layer.masksToBounds = YES;
        [_panelView addTarget:self action:@selector(handleClick) forControlEvents:UIControlEventTouchUpInside];
        [_panelView setUserInteractionEnabled:YES];

        [self addSubview:_panelView];
        
        self.imgAry = [NSArray arrayWithObjects:[UIImage imageNamed:@"otherplay_0.png"], [UIImage imageNamed:@"otherplay_1.png"], [UIImage imageNamed:@"otherplay_2.png"], nil];
        
        _nWidth = CELL_FOR_VOICE_WIDTH;
        
        _playVoiceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, PLAY_VOICE_IMAGE_VIEW_WIDTH, PLAY_VOICE_IMAGE_VIEW_HEIGHT)];
        _playVoiceView.backgroundColor = [UIColor clearColor];
        [_playVoiceView setUserInteractionEnabled:NO];
        [_panelView addSubview:_playVoiceView];
        
        _showTime = [[UILabel alloc] init];
        _showTime.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        _showTime.textColor = [UIColor whiteColor];
        _showTime.backgroundColor = [UIColor clearColor];
        _showTime.textAlignment = NSTextAlignmentLeft;
        [_showTime setUserInteractionEnabled:NO];

        NSString* voicetime = [VoiceBubbleView secondsToVoiceMessageDurationForamt:duration];
        _showTime.text = voicetime;
        [_panelView addSubview:_showTime];
        
        _switchView = [[DTUISwitchBar alloc] initWithFrame:CGRectZero];
        _switchView.hidden = YES;
        [_switchView addTarget:self action:@selector(auidoRouteSwitch:)];
        [_switchView setUserInteractionEnabled:YES];
        [self addSubview:_switchView];
        
        self.userInteractionEnabled = YES;

        [_switchView setOn:(spState == kVoiceMessageAudioRouteSpeaker)];

        [self initVoiceViewState];
 
        [self setFrame];
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onVoiceUpdate:) name:kNotificationVoiceUpdate object:nil];
    }
    
    return self;
}

- (void)onVoiceUpdate:(NSNotification*)notification
{
    NSLog(@"voice remain time: %d", [((NSNumber*)notification.object)intValue]);
    [self updateUIForPlayState];
}

- (void)initVoiceViewState
{
    //TODO: create delegate
    _state = kVoiceBubbleStateWhite;
    
    NSString* imgName = nil;

    imgName = [NSString stringWithFormat:@"othervoice_%d.png", (int)_state];
 
    self.baseImage = [UIImage imageNamed:imgName];
    [self setVoiceImage];
}

- (void)setVoiceImage
{
    if (self.baseImage != nil)
    {
        [_playVoiceView setImage:self.baseImage];
    }
}

- (void)setFrame
{
    _nWidth = CELL_FOR_VOICE_WIDTH; // 56
    int durationInSeconds = VOICE_MAIL_INIT_DURATION;
    
    if (durationInSeconds > 0 && durationInSeconds <= 30)
    {
        _nWidth += (durationInSeconds*2);
    }
    else if (durationInSeconds > 30)
    {
        _nWidth += 60;
    }
    _panelView.frame = CGRectMake(0, 0, _nWidth, CELL_FOR_VOICE_HEIGHT);

    _playVoiceView.frame = CGRectMake(10, (CELL_FOR_VOICE_HEIGHT - PLAY_VOICE_IMAGE_VIEW_HEIGHT)/2, PLAY_VOICE_IMAGE_VIEW_WIDTH, PLAY_VOICE_IMAGE_VIEW_HEIGHT);

    CGSize size = [_showTime.text sizeWithFont:_showTime.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _showTime.frame = CGRectMake(_nWidth - size.width - 10, (CELL_FOR_VOICE_HEIGHT- size.height)/2, size.width+10, size.height);

    float timeLabelHeight = 0.0f;
    timeLabelHeight = kTimeLabelHeight + kTimeLabelOffsetY;
    _switchView.frame = CGRectMake(CGRectGetMaxX(_panelView.frame) + kSwitchBubbleOffset, (_panelView.frame.size.height - kSwitchHeight)/2 + CGRectGetMinY(_panelView.frame), KSwitchWidth, kSwitchHeight);
    
    self.frame = CGRectMake(_startPoint.x, _startPoint.y, CGRectGetMaxX(_switchView.frame), CELL_FOR_VOICE_HEIGHT);
}

- (IBAction)auidoRouteSwitch:(id)sender
{

    if (_vbDelegate && [_vbDelegate respondsToSelector:@selector(audioSwitched:)])
    {
        [_vbDelegate audioSwitched:![sender isOn]];
    }

}
+ (NSString*)secondsToVoiceMessageDurationForamt:(int)seconds
{
    int hour = seconds / 3600;
    int minute = (seconds - hour * 3600) / 60;
    int second = seconds - hour * 3600 - minute * 60;
    
    NSString* displayTime = @"0\"";
    if(hour > 0)
    {
        if(hour == 1)
        {
            displayTime = [NSString stringWithFormat:@"%d hour %d'%d\"",hour,minute,second];
        }
        else
        {
            displayTime = [NSString stringWithFormat:@"%d hours %d'%d\"",hour,minute,second];
        }
    }
    else
    {
        if (minute == 0)
        {
            displayTime = [NSString stringWithFormat:@"%d\"", second];
        }
        else
        {
            displayTime = [NSString stringWithFormat:@"%d'%d\"",minute,second];
        }
    }
    
    return displayTime;
}

- (void)startPlayVoiceView
{
    if (self.imgAry == nil || [self.imgAry count] == 0)
    {
        return;
    }
    
    if ([self.imgAry count] > 1 && [_playVoiceView isAnimating] == NO)
    {
        _playVoiceView.animationImages = self.imgAry;
        _playVoiceView.animationDuration = 0.8;
        _playVoiceView.animationRepeatCount = 0;
        [_playVoiceView startAnimating];

        if (_vbDelegate && [_vbDelegate respondsToSelector:@selector(getAudioRotateState)])
        {
            VoiceMessageAudioRoute audioState = [_vbDelegate getAudioRotateState];
            if(audioState == kVoiceMessageAudioRouteSpeaker)
            {
                [self updateSwitchIcon:YES];
            }
            else if(audioState == kVoiceMessageAudioRouteEarphone)
            {
                [self updateSwitchIcon:NO];
            }
        }

    }
}

- (void)stopPlayVoiceView
{
    [_playVoiceView stopAnimating];
    [_playVoiceView setImage:self.baseImage];

    [self setFrame];
    
}
- (void)updateSwitchIcon:(BOOL)isSpeaker
{
    [_switchView setOn:!isSpeaker];
}
- (void)updateUIForPlayState
{
    int duration = [_vbDelegate getDuration];;
    NSString* voicetime = [VoiceBubbleView secondsToVoiceMessageDurationForamt:duration];
    _showTime.text = voicetime;
    
    enum_VoiceMail_PlayState playState = [self.vbDelegate getPlayState];
    if (playState == enum_VoiceMail_PlayState_Playing)
    {
        _switchView.hidden = NO;
        self.baseImage = [UIImage imageNamed:@"othervoice_0.png"];
  
        [self startPlayVoiceView];
        //[[DTVoiceMailMgr shareInstance] setDelegate:self];
    }
    else if (playState == enum_VoiceMail_PlayState_Pause)
    {
        NSString* strImg = nil;

        strImg = [NSString stringWithFormat:@"othervoice_%d.png", 0];

        self.baseImage = [UIImage imageNamed:strImg];
        _switchView.hidden = YES;
        [self stopPlayVoiceView];
    }
    else if (playState == enum_VoiceMail_PlayState_Stop || playState == enum_VoiceMail_PlayState_Invalid)
    {
        if (_vbDelegate && [_vbDelegate respondsToSelector:@selector(getDuration)]) {
            NSString* strImg = [NSString stringWithFormat:@"othervoice_%d.png", 0];
            self.baseImage = [UIImage imageNamed:strImg];
            _switchView.hidden = YES;
            [self stopPlayVoiceView];
        }

    }
}

@end
