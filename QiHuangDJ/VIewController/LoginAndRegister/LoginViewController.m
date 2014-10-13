//
//  LoginViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "LoginViewController.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg@2x.png"]]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if (self.delegate && [self.delegate respondsToSelector:@selector(onLoginSuccess)]) {
//        [self.delegate onLoginSuccess];
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressCancel:(UIButton *)sender
{
    [self.delegate onLoginFailed];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)pressCommit:(UIButton *)sender
{
    [self.delegate onLoginSuccess];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)pressInterrelatedLoginWithQQ:(UIButton *)sender
{
    NSLog(@"Q泥煤呀");
}

- (IBAction)pressInterrelatedLoginWithWeibo:(UIButton *)sender
{
    NSLog(@"微个博呀");
}

- (IBAction)pressRegisterButton:(UIButton *)sender
{
    NSLog(@"点这里呀");
}







@end
