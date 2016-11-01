//
//  BubblePanelView.m
//  VoiceBubble
//
//  Created by kelvin on 15/11/20.
//  Copyright © 2015年 kelvin. All rights reserved.
//

#import "BubblePanelView.h"

@implementation BubblePanelView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = nil;
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        //实例化长按手势监听
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleLongPress:)];
        
        [self addGestureRecognizer:longPress];
        
    }
    return self;
}
- (void)handleLongPress:(UILongPressGestureRecognizer*) sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSUInteger numberOfTouches = [sender numberOfTouches];
        if (numberOfTouches < 1)
        {
            return;
        }
        /*
         NSMutableSet* points = [[[NSMutableSet alloc]init]autorelease];
         for (int i = 0; i < numberOfTouches; ++i) {
         CGPoint point = [sender locationOfTouch:i inView:self];
         NSValue* value = [NSValue valueWithCGPoint:point];
         [points addObject:value];
         
         }
         */
        CGPoint point = [sender locationOfTouch:0 inView:self];
        
        if (_delegate && [_delegate respondsToSelector:@selector(bubblePanelViewDidLongPress:)])
        {
            NSValue* ptValue = [NSValue valueWithCGPoint:point];
            [_delegate performSelector:@selector(bubblePanelViewDidLongPress:) withObject:ptValue];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(bubblePanelViewDidClicked:)]) {
        [_delegate performSelector:@selector(bubblePanelViewDidClicked:) withObject:touches];
    }
    [super touchesEnded:touches withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end

