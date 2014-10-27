//
//  VideoLiveViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "VideoLiveViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface VideoLiveViewController () {

}

@end

@implementation VideoLiveViewController {
    MPMoviePlayerViewController * moviePlay;
    __weak IBOutlet UIView *mediaPlayBGView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setCascTitle:@"直播"];
        [self setFanhui];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self playerBuildUI:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];

}

-(void)playerBuildUI:(NSString *)urlStr {
    //实体化MediaPlayer播放器
    NSURL * url = [NSURL URLWithString:urlStr];
    moviePlay = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self.presentedViewController presentMoviePlayerViewControllerAnimated:moviePlay];
    moviePlay.moviePlayer.scalingMode = MPMovieScalingModeFill;
//    moviePlay.moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlay.moviePlayer.shouldAutoplay = YES;

    [moviePlay.view setFrame:mediaPlayBGView.bounds];
//    [mediaPlayBGView addSubview:moviePlay.view];
    
    // 播放器的按钮的view
    UIView * view = [UIView new];
    view.frame = CGRectMake(0,(mediaPlayBGView.frame.size.height - 40)/2, mediaPlayBGView.frame.size.width, 40);
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.4f;
    [mediaPlayBGView addSubview:view];
    
    //使播放器全屏的按钮
    UIButton *fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fullScreenBtn.frame = CGRectMake(view.frame.size.width- view.frame.size.height, 0, view.frame.size.height, view.frame.size.height);
    [fullScreenBtn setTitle:@"全屏" forState:UIControlStateNormal];
    [fullScreenBtn addTarget:self action:@selector(fuScreenMethod:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:fullScreenBtn];
    
    [moviePlay.moviePlayer play];
}

- (void)fuScreenMethod:(UIButton *)sender{
    mediaPlayBGView.transform=CGAffineTransformIdentity;
    
    if (sender.selected) {
        //全屏转半屏

        sender.selected = NO;
    } else {
        //半屏转全屏
        
        sender.selected = YES;
        
    }
    
}
@end
