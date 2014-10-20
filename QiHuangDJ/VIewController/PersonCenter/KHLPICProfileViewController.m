//
//  KHLPICProfileViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-20.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLPICProfileViewController.h"

@interface KHLPICProfileViewController ()

@end

@implementation KHLPICProfileViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:@"个人资料"];
    [self setFanhui];
    [self drawRightNavigationButton];
}



#pragma mark - LAYOUT CUSTOM METHODES

- (void)drawRightNavigationButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun@2x.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_btn_baocun_press@2x.png"] forState:UIControlStateHighlighted];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 42, 27)];
    [btn setTitleColor:[KHLColor colorFromHexRGB:@"FE6024"] forState:UIControlStateNormal];
    [btn.titleLabel setFont: [UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(pressSaveButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightNavigationBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightNavigationBarButton;
}



#pragma mark - USER INTERACTION RESPONSE

- (void)pressSaveButton
{
    NSLog(@"保个存呀");
}


@end
