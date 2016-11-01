//
//  VoiceBubbleView.m
//  VoiceBubble
//
//  Created by kelvin on 15/11/20.
//  Copyright © 2015年 kelvin. All rights reserved.
//

#import "VoiceBubbleView.h"

#define CELL_FOR_VOICE_WIDTH  56
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
#define kSwitchBubbleOffset 5.0f

#define VOICE_MESSAGE_DURATION_MS_TO_S(x)  (int)(round((x)/1000.0))


#define VOICE_MAIL_INIT_DURATION    20

@implementation VoiceBubbleView

- (id)init
{
    self = [super init];
    if (self)
    {
        self.imgAry = [NSArray arrayWithObjects:[UIImage imageNamed:@"otherplay_0.png"], [UIImage imageNamed:@"otherplay_1.png"], [UIImage imageNamed:@"otherplay_2.png"], nil];
        
        _nWidth = CELL_FOR_VOICE_WIDTH;

        _playVoiceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, PLAY_VOICE_IMAGE_VIEW_WIDTH, PLAY_VOICE_IMAGE_VIEW_HEIGHT)];
        _playVoiceView.backgroundColor = [UIColor clearColor];
        
        _showTime = [[UILabel alloc] initWithFrame:CGRectMake(_nWidth - 24, 8, 35, 15)];
        _showTime.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        _showTime.textColor = [UIColor whiteColor];
        _showTime.backgroundColor = [UIColor clearColor];
        _showTime.textAlignment = NSTextAlignmentLeft;
        
        int duration = [self getPlayRemainDuration];
        if (duration < 0) {
            duration = VOICE_MAIL_INIT_DURATION;
        }
        NSString* voicetime = [VoiceBubbleView secondsToVoiceMessageDurationForamt:duration];
        _showTime.text = voicetime;
        
        
        _switchView = [[DTUISwitchBar alloc] initWithFrame:CGRectZero];
        [self addSubview:_switchView];
        _switchView.hidden = YES;
        [_switchView addTarget:self action:@selector(auidoRouteSwitch:)];
        
        _lbVoiceMail = [[UILabel alloc] init];
        _lbVoiceMail.backgroundColor = [UIColor clearColor];
        _lbVoiceMail.textColor = [UIColor whiteColor];
        _lbVoiceMail.font = [UIFont systemFontOfSize:12.0];
        _lbVoiceMail.text = NSLocalizedString(@"Voice mail", @"");
        //CGSize size = [_lbVoiceMail.text sizeWithFont:_lbVoiceMail.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGRect size = _lbVoiceMail.text boundingRectWithSize:CGSizeMake(100, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil
        _lbVoiceMail.frame = CGRectMake(0, 0, size.width, size.height);
        
    }

    return self;
}

- (IBAction)auidoRouteSwitch:(id)sender
{
    
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

- (int)getPlayRemainDuration
{
    return _remianDuration;
}
@end
