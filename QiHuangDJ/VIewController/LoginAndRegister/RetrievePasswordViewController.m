//
//  RetrievePasswordViewController.m
//  QiHuangDJ
//
//  Created by 朱子瀾 on 14-11-21.
//  Copyright (c) 2014年 朱子瀾. All rights reserved.
//

#import "RetrievePasswordViewController.h"

@interface RetrievePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@end

@implementation RetrievePasswordViewController



#pragma mark - VIEW CONTROLLER LIFECYCLE

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setCascTitle:@"找回密码"];
        [self setFanhui];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Register notifications..
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrievePasswordNotified:) name:@"KHLNotiRetrievePassword" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove notifications..
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiRetrievePassword" object:nil];
}



#pragma mark - USER INTERACTION RESPONSES

- (IBAction)clickRetrievePasswordButton:(UIButton *)sender
{
    NSString *email = self.emailTextField.text;
    if (email && ![@"" isEqualToString:email]) {
        [[KHLDataManager instance] retrievePasswordHUDHolder:self.view email:email];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮箱地址。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
}



#pragma mark - NOTIFICATION METHODES

- (void)retrievePasswordNotified: (NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    if (!dict) {
        NSLog(@"妈蛋，返回nil了。");
        [[[UIAlertView alloc] initWithTitle:@"系统错误" message:@"未知错误发生。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if ([[dict objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        [[[UIAlertView alloc] initWithTitle:@"找回密码申请成功" message:@"密码找回邮件将会发送至邮箱。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"找回密码申请失败" message:[dict objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}










@end
