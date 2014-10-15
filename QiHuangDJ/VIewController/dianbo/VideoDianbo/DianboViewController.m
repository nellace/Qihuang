//
//  DianboViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "DianboViewController.h"
//#import "LTPlayerSDK.h"
//#import <AVFoundation/AVFoundation.h>
@interface DianboViewController ()

@end

@implementation DianboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setCascTitle:@"点播"];
        [self setFanhui];
    }
//    <LTPlayerDelegate>
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//
//    [LTPlayerSDK showWithUserUnique:@"0b3f52f107"
//                        videoUnique:@"6b4a85f298"
//                          videoName:@""
//                          payerName:@""
//                          checkCode:@""
//                                 ap:YES
//                   inViewController:self
//                     playerDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
