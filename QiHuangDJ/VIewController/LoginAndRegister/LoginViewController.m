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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginMethod:) name:@"KHLNotiLogin" object:nil];
    
    [self setAutoLogin:TRUE];
    [self.usernameTextField setBackgroundColor:[UIColor clearColor]];
    [self.passwordTextField setBackgroundColor:[UIColor clearColor]];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名/邮箱" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewDidDisappear:(BOOL)animated {
    //移除登录通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KHLNotiLogin" object:nil];
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
    if (self.usernameTextField.text.length ==0 ) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!(self.usernameTextField.text.length>=3 && self.usernameTextField.text.length<=9)) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名长度3-9个字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ( self.passwordTextField.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!(self.passwordTextField.text.length>=6 && self.passwordTextField.text.length<=20)) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度6-20个字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [[KHLDataManager instance] loginHUDHolder:self.view loginName:self.usernameTextField.text password:self.passwordTextField.text];
}

- (void)loginMethod:(NSNotification *)aNotification {
    NSDictionary * loginDic = aNotification.object;
    if (loginDic == nil) {
        NSLog(@"login failed  loginDic = nil");
        return;
    }
    NSLog(@"loginDic %@  reason%@",loginDic,[loginDic objectForKey:@"reason"]);
    if ([[loginDic objectForKey:@"resultCode"] isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:[loginDic objectForKey:@"reason"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([[loginDic objectForKey:@"resultCode"] isEqualToString:@"0"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        NSDictionary * dic = [loginDic objectForKey:@"result"];
        
        LoginVC * login = [LoginVC new];
        login.phone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile"]] ;
        
        [self.delegate onLoginSuccess];
        //[self dismissViewControllerAnimated:TRUE completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
        //从NSUserDefaults中存数据
        [[NSUserDefaults standardUserDefaults] setObject:login.phone forKey:@"mobile"];
        //从NSUserDefaults中取数据
        [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
        return;
    }
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
