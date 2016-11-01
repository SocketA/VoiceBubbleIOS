//
//  VoiceBubbleView.h
//  VoiceBubble
//
//  Created by kelvin on 15/11/20.
//  Copyright © 2015年 kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTUISwitchBar.h"
#import "BubblePanelView.h"
enum
{
    kVoiceBubbleStateBlack,  // black
    kVoiceBubbleStateWhite,  // white
    kVoiceBubbleStateBlackWhite, // first is black ,other is white
    kVoiceBubblePlay, // play
};
typedef NSInteger VoiceBubbleState;


typedef enum
{
    kVoiceMessageAudioRouteEarphone,
    kVoiceMessageAudioRouteSpeaker,
}VoiceMessageAudioRoute;

typedef enum enum_VoiceMail_PlayState
{
    enum_VoiceMail_PlayState_Invalid,
    enum_VoiceMail_PlayState_Playing,
    enum_VoiceMail_PlayState_Pause,
    enum_VoiceMail_PlayState_Stop,
}enum_VoiceMail_PlayState;

#define kNotificationVoiceUpdate    @"voiceUpdate"

@protocol VoiceBubbleViewDelegate <NSObject>

- (enum_VoiceMail_PlayState)getPlayState;
- (VoiceMessageAudioRoute)getAudioRotateState;
- (void)audioSwitched:(BOOL)on;
- (int)getDuration;
- (void)play;
@end

@interface VoiceBubbleView : UIView<BubblePanelViewDelegate, UIGestureRecognizerDelegate>
{
    UIButton* _panelView;
    
    UIImageView* _playVoiceView;
    
    UILabel*     _showTime;
    
    DTUISwitchBar*   _switchView;
    
    NSUInteger   _nWidth;

    VoiceMessageAudioRoute _audioRoute;
    
    VoiceBubbleState _state;

//    id<BubblePanelViewDelegate> _delegate;
}
@property (nonatomic, retain)NSArray*   imgAry;
@property (nonatomic, retain)UIImage*   baseImage;
@property (nonatomic, retain)id<VoiceBubbleViewDelegate> vbDelegate;

- (id)initWithPosition: (CGPoint)point andDuration:(int)duration speakerState:(VoiceMessageAudioRoute)spState;

@end
