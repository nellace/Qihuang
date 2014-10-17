//
//  KHLPICAboutUsViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-17.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLPICAboutUsViewController.h"

@interface KHLPICAboutUsViewController ()

@end

@implementation KHLPICAboutUsViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:@"关于七煌"];
    [self setFanhui];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
