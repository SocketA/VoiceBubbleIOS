//
//  Voice.h
//  VoiceBubble
//
//  Created by kelvin on 15/11/25.
//  Copyright © 2015年 kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoiceBubbleView.h"

@interface Voice : NSObject<VoiceBubbleViewDelegate>
{
    int _initDuration;
    NSTimer* _timer;
}

- (id)initWithDuration:(int)du;

- (int)getDuration;

- (VoiceMessageAudioRoute)getAudioRotateState;

@property(nonatomic, assign)int duration;

@property(nonatomic, assign)enum_VoiceMail_PlayState playState;

@property(nonatomic, assign)VoiceMessageAudioRoute audioRoute;

@end
