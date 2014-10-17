//
//  LoginViewController.m
//  QiHuangDJ
//
//  Created by liuxiaolong on 14-9-18.
//  Copyright (c) 2014年 liuxiaolong. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginButton;
@property (nonatomic, setter = setAutoLogin:, getter = isAutoLogin) BOOL bAutoLogin;
@end

@implementation LoginViewController



#pragma mark VIEW CONTROLLER LIFECYCLE

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // ..
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg@2x.png"]]];
    [self setCascTitle:@"登录"];
    [self setFanhui];
    
    [self setAutoLogin:TRUE];
    [self.usernameTextField setBackgroundColor:[UIColor clearColor]];
    [self.passwordTextField setBackgroundColor:[UIColor clearColor]];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名/邮箱" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



# pragma mark ATTRIBUTES GETTER AND SETTER

- (void)setAutoLogin:(BOOL)bAutoLogin
{
    _bAutoLogin = bAutoLogin;
    if (_bAutoLogin) {
        [self.autoLoginButton setImage:[UIImage imageNamed:@"denglu_zidongdenglu_press.png"]
                              forState:UIControlStateNormal];
    } else {
        [self.autoLoginButton setImage:[UIImage imageNamed:@"denglu_zidongdenglu.png"]
                              forState:UIControlStateNormal];
    }
}




# pragma mark USER INTERACTION RESPONSE

- (IBAction)pressCancel:(UIButton *)sender
{
    [self.delegate onLoginFailed];
    //[self dismissViewControllerAnimated:TRUE completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressCommit:(UIButton *)sender
{
    [self.delegate onLoginSuccess];
    //[self dismissViewControllerAnimated:TRUE completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    //    [self presentViewController:registerVC animated:YES completion:nil];
    
    //    classify.title = @"注册";
    //    [self.navigationController pushViewController:classify animated:YES];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)pressAutoLoginButton:(UIButton *)sender
{
    self.bAutoLogin = !self.bAutoLogin;
}

- (IBAction)pressForgotPasswordButton:(UIButton *)sender
{
    NSLog(@"忘密码呀");
}





@end
