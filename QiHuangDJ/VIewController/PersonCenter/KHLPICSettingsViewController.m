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
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation KHLPICSettingsViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (void)viewWillAppear:(BOOL)animated
{
    [self setCascTitle:@"设置"];
    [self setFanhui];
    if (![self displayLogoutButton]) {
        [self.logoutButton setHidden:TRUE];
    }
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIUID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIUsername"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIPhoneNumber"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIGender"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIBirthday"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIBlog"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIRegisterTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIEmail"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KHLPIQQ"];
    
    [self.delegate onLogoutSuccess];
    [self.navigationController popViewControllerAnimated:TRUE];
}


@end
