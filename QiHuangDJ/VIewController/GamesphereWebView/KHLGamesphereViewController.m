//
//  KHLGamesphereViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-11-5.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLGamesphereViewController.h"

@interface KHLGamesphereViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, getter=needsRefresh, setter=setNeedsRefresh:) BOOL refreshTag;

@end

@implementation KHLGamesphereViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setCascTitle:@"游戏圈"];
        [self setFanhui];
        [self setNeedsRefresh:TRUE];
    }
    
    return self;
}

- (void)viewDidLoad
{
    if ([self needsRefresh]) {
        // http://www.175kh.com/app/index.html
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.175kh.com/app/index.html"]]];
        [self setNeedsRefresh:FALSE];
    }
}
















@end
