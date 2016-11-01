//
//  DTUISwitchBar.h
//  PFIMCLient
//
//  Created by xjy on 12-11-28.
//  Copyright (c) 2012年 Dington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DTUISwitchBar : UIView<UIScrollViewDelegate>
{
    UIScrollView* _baseView;
    UIImageView*  _showImageView;

    BOOL    _bOn;
}

@property(nonatomic, retain)UIScrollView* baseView;
@property(nonatomic, retain)UIImageView* showImageView;


// set image
-(void)setImageView:(UIImage*)image;

-(void)clickImage:(UIGestureRecognizer *)sender;

-(void)setOn:(BOOL)isRet;
-(BOOL)isOn;

- (void)addTarget:(id)target action:(SEL)action;

@end
