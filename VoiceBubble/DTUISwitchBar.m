//
//  DTUISwitchBar.m
//  PFIMCLient
//
//  Created by xjy on 12-11-28.
//  Copyright (c) 2012年 Dington. All rights reserved.
//
#import <QuartzCore/CALayer.h>
#import "DTUISwitchBar.h"

@interface DTUISwitchBar()

@property(nonatomic, retain)id target;
@property(nonatomic) SEL action;

@end

@implementation DTUISwitchBar

@synthesize baseView = _baseView;
@synthesize showImageView = _showImageView;
@synthesize target = target_;
@synthesize action = action_;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 14;
        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 2;
//        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 98, 28)];
        [self.baseView setBackgroundColor:[UIColor clearColor]];
        [self.baseView setBounces:NO];
        [self.baseView setShowsHorizontalScrollIndicator:NO];
        [self.baseView setShowsVerticalScrollIndicator:NO];
        [self.baseView setDelegate:self];
        self.baseView.contentSize = CGSizeMake(171, 28);
        [self.baseView setContentOffset:CGPointMake(0, 0)];
        UITapGestureRecognizer* switchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
        [self.baseView addGestureRecognizer:switchTap];
        self.baseView.scrollsToTop = NO;

        
        UIImageView *voiceBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_switch_bk.png"]];
        voiceBack.frame = CGRectMake(0, 0, 171, 28);
        voiceBack.backgroundColor = [UIColor clearColor];
        
//        UILabel *speaker = [[UILabel alloc] initWithFrame:CGRectMake(22, 1, 50, 20)];
//        speaker.backgroundColor = [UIColor clearColor];
//        speaker.font = [UIFont boldSystemFontOfSize:12];
//        speaker.textColor = [UIColor whiteColor];
//        speaker.textAlignment = UITextAlignmentCenter;
//        speaker.text = "Speaker";
//        [voiceBack addSubview:speaker];
//        [speaker release];
//        
//        UILabel *radio = [[UILabel alloc] initWithFrame:CGRectMake(90, 1, 60, 20)];
//        radio.backgroundColor = [UIColor clearColor];
//        radio.font = [UIFont boldSystemFontOfSize:12];
//        radio.textColor = [UIColor whiteColor];
//        radio.textAlignment = UITextAlignmentCenter;
//        radio.text = "Earphone";
//        [voiceBack addSubview:radio];
//        [radio release];
        
        self.showImageView = voiceBack;

        [self.baseView addSubview:self.showImageView];
        [self addSubview:self.baseView];
        _bOn = NO; // showleft
    }
    
    return self;
}

// set image
- (void)setImageView:(UIImage*)image
{
    
}

- (void)clickImage:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (_bOn == NO)
        {
            
            [self setOn:YES];
        }
        else
        {
            
            [self setOn:NO];
        }
        
        [target_ performSelector:action_ withObject:self];
    }
}

- (void)setOn:(BOOL)isRet
{
    //NSLog(@"XXXXXXXXXXXXXX: %@", (isRet ? @"Speak" : @"Radio"));
    
    CGSize  size = self.baseView.contentSize;
    _bOn = isRet;
    if(_bOn)
    {
        [self.baseView setContentOffset:CGPointMake(size.width/2 - 13, 0) animated:NO];
    }
    else
    {
        [self.baseView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

- (BOOL)isOn
{
    return _bOn;
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

#pragma mark UIScrollViewDelegate

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint point = scrollView.contentOffset;
    CGSize  size = self.baseView.contentSize;
    CGRect frame = self.baseView.frame;
    if (point.x + frame.origin.x < size.width/4)
    {
//        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        if ([self isOn]) {
            [target_ performSelector:action_ withObject:self];
        }
        [self setOn:NO];
    }
    else
    {
//        [scrollView setContentOffset:CGPointMake(size.width/2 - 7, 0) animated:YES];
        if (![self isOn]) {
            [target_ performSelector:action_ withObject:self];
        }
        [self setOn:YES];
    }
}


@end
