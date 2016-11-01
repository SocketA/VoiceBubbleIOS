//
//  ViewController.m
//  VoiceBubble
//
//  Created by kelvin on 15/11/20.
//  Copyright © 2015年 kelvin. All rights reserved.
//

#import "ViewController.h"
#import "VoiceBubbleView.h"
#import "Voice.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Voice* voice = [[Voice alloc]initWithDuration:10];
    VoiceBubbleView* voiceBubble = [[VoiceBubbleView alloc]initWithPosition:CGPointMake(20, 200) andDuration:[voice getDuration] speakerState: [voice getAudioRotateState]];
    voiceBubble.vbDelegate = voice;
    [self.view addSubview:voiceBubble];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
