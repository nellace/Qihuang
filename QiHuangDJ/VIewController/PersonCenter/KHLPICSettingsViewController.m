//
//  KHLPICSettingsViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-10-16.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "KHLPICSettingsViewController.h"
#import "KHLPICAboutUsViewController.h"

@interface KHLPICSettingsViewController ()

@property (nonatomic, getter=isMessagePushAllowed, setter=setMessagePushAllowed:) BOOL bMessagePushAllowed;

@end

@implementation KHLPICSettingsViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:@"设置"];
    [self setFanhui];
}



#pragma mark - USER INTERACTION METHODES

// Toggle message push allowed..
- (IBAction)toggleMessagePush:(UISwitch *)sender
{
    [self setMessagePushAllowed:sender.isOn];
}

// Clean memory cache..
- (IBAction)pressCacheCleanButton:(UIButton *)sender
{
    
}

// Push to about keahoarl view controller..
- (IBAction)pressAboutUsButton:(UIButton *)sender
{
    KHLPICAboutUsViewController *aboutUsViewController = [[KHLPICAboutUsViewController alloc] init];
    [self.navigationController pushViewController:aboutUsViewController animated:TRUE];
}

- (IBAction)pressContactUsButton:(UIButton *)sender
{
    
}

- (IBAction)pressLogOutButton:(UIButton *)sender
{
    [self.delegate onLogoutSuccess];
    //[self dismissViewControllerAnimated:TRUE completion:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}


@end
