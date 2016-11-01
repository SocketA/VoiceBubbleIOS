//
//  BubblePanelView.h
//  VoiceBubble
//
//  Created by kelvin on 15/11/20.
//  Copyright © 2015年 kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BubblePanelViewDelegate;
@interface BubblePanelView : UIImageView

@property (nonatomic, assign) id<BubblePanelViewDelegate> delegate;

@end


@protocol BubblePanelViewDelegate<NSObject>
@optional
- (void)bubblePanelViewDidClicked:(NSSet *)touches;
- (void)bubblePanelViewDidLongPress:(NSValue*)ptValue;
@end