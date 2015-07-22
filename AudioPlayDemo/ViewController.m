//
//  ViewController.m
//  AudioPlayDemo
//
//  Created by quiet on 15/7/22.
//  Copyright (c) 2015年 quiet. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "ZTQuickControl.h"

#import "AudioStreamer.h"

@interface ViewController ()
{
    
}
@property (strong,nonatomic) AVAudioPlayer *player;
@property (strong,nonatomic) UIProgressView *progressView;
@property (strong,nonatomic) AudioStreamer *streamer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //演示音频文件的播放
    //项目应用: 实现音乐播放器(酷狗音乐,虾米音乐)
    
    //1.本地mp3文件播放 AVFoundation.framework
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lalala.mp3" ofType:nil];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.player prepareToPlay];    //准备播放(缓冲数据)
    
    __weak typeof(self) ws = self;
    [self.view addSystemButtonWithFrame:CGRectMake(100, 100, 100, 30) title:@"播放" action:^(ZTButton *button) {
        
        if(![ws.player isPlaying])
        {
            [ws.player play];
            [button setTitle:@"暂停" forState:UIControlStateNormal];
        }
        else
        {
            [ws.player pause];
            [button setTitle:@"播放" forState:UIControlStateNormal];
        }
        
    }];
    
    //(2)播放进度控制
    //当前时间: currentTime 90s
    //持续时间: duration    180s
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 150, 280, 20)];
    [self.view addSubview:self.progressView];
    //仿射变换(控件旋转, 缩放, 位置, 3D旋转)
    //  CGAffineTransform 核心动画转化对象
    _progressView.transform = CGAffineTransformMakeScale(1, 3);
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(dealTimer) userInfo:nil repeats:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealTap:)];
    [_progressView addGestureRecognizer:tap];
    
    //(3)音量控制
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 200, 280, 30)];
    [slider addTarget:self action:@selector(dealSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:slider];
    //slider.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    slider.value = 0.5;
    _player.volume = 0.5;
    
    //2.在线mp3文件播放
    // http://yinyueshiting.baidu.com/data2/music/134367314/121367437219600128.mp3?xcode=bfb842f640727b97350a5c038dd045b5
    [self.view addSystemButtonWithFrame:CGRectMake(100, 300, 100, 30) title:@"播放在线mp3" action:^(ZTButton *button) {
        NSString *urlString = @"http://yinyueshiting.baidu.com/data2/music/134367314/121367437219600128.mp3?xcode=bfb842f640727b97350a5c038dd045b5";
        _streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:urlString]];
        [ws.streamer start];
    }];
    
    
}
-(void)dealSlider:(UISlider *)slider
{
    _player.volume = slider.value;
}


-(void)dealTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"dealTap");
    CGPoint point = [tap locationInView:_progressView];
    double time = _player.duration * (point.x / _progressView.frame.size.width);
    _player.currentTime = time;

}
-(void)dealTimer
{
    if(!_player.duration)
    {
        return;
    }
    double progress = _player.currentTime / _player.duration;
    _progressView.progress = progress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
